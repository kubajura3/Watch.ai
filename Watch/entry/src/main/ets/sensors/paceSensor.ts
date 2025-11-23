import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError } from '@kit.BasicServicesKit';

interface PaceResponse {
  paceMonitor?: number;
  value?: number;
}

interface Location {
  latitude: number;
  longitude: number;
}

type PMListener = (pm: number, ps: string) => void;

const EARTH_RADIUS_M = 6371000;

export default class PaceMonitor {
  private static paceMonitor = 0;
  private static listeners = new Set<PMListener>();

  // Stores the ID for the location change subscription
  private static locationRequestId: number | null = null;
  // Stores the last known location for calculations
  private static lastLocation: geoLocationManager.Location | null = null;

  isLocationSettingOpen() {
    return geoLocationManager.isLocationEnabled();
  }

  // Component subscribes to heart rate changes
  static subscribe(cb: PMListener) {
    this.listeners.add(cb);
    // Start the sensor the first time someone subscribes
    if (this.listeners.size === 1) this.start();
    // Returns the current value immediately (optional)
    cb(this.paceMonitor, this.format(this.paceMonitor));
  }

  // Unsubscribe
  static unsubscribe(cb: PMListener) {
    this.listeners.delete(cb);
    // Stop the sensor if no one is listening
    if (this.listeners.size === 0) this.stop();
  }
  private static _calculateHaversineDistance(loc1: Location, loc2: Location): number {
    // Helper to convert degrees to radians
    const toRadians = (degrees: number): number => degrees * (Math.PI / 180);

    const lat1 = loc1.latitude;
    const lon1 = loc1.longitude;
    const lat2 = loc2.latitude;
    const lon2 = loc2.longitude;

    const dLat = toRadians(lat2 - lat1);
    const dLon = toRadians(lon2 - lon1);

    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(toRadians(lat1)) * Math.cos(toRadians(lat2)) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    const distance = EARTH_RADIUS_M * c; // Distance in meters

    return distance;
  }

  private static calculatePace(currentLoc: geoLocationManager.Location): void {
    const minMetersPerSecond = 0.5; // Threshold to filter out very slow movement noise (0.5 m/s approx 3 min/km)

    if (this.lastLocation) {
      // 1. Calculate Time Difference (in seconds)
      const timeDifferenceMs = currentLoc.timeStamp - this.lastLocation.timeStamp;
      const timeDifferenceSec = timeDifferenceMs / 1000;

      // 2. Calculate Distance Difference (in meters)
      // distanceTo returns the distance in meters
      const distanceDifferenceM = PaceMonitor._calculateHaversineDistance({
        latitude: this.lastLocation.latitude,
        longitude: this.lastLocation.longitude
      }, {
        latitude: currentLoc.latitude,
        longitude: currentLoc.longitude
      });

      // 3. Calculate Pace (Speed = Distance / Time) in m/s
      let currentPace = 0;
      if (timeDifferenceSec > 0 && distanceDifferenceM > 0) {
        currentPace = distanceDifferenceM / timeDifferenceSec;
      }

      // Filter noise: Set pace to 0 if the calculated speed is very low
      // but only if the device itself reports 0 speed (or if the calculated speed is below the threshold).
      // The `speed` property from Location is often more smoothed and accurate.
      const reportedSpeed = currentLoc.speed || 0;

      // Use reported speed if available and seems reasonable, otherwise use calculated pace
      if (reportedSpeed > minMetersPerSecond) {
        this.paceMonitor = reportedSpeed;
      } else if (currentPace > minMetersPerSecond) {
        this.paceMonitor = currentPace;
      } else {
        this.paceMonitor = 0; // Considered stopped or very slow
      }

    } else if (currentLoc.speed) {
      // For the very first location update, use the reported speed if available.
      this.paceMonitor = currentLoc.speed;
    }

    this.lastLocation = currentLoc;

    // Notify all subscribers
    const formattedPace = this.format(this.paceMonitor);
    this.listeners.forEach(fn => fn(this.paceMonitor, formattedPace));
    console.info('[PM]', `Pace updates -> ${this.paceMonitor.toFixed(2)} m/s, ${formattedPace}`);
  }

  private static start() {
    console.info('[PM]', 'Starting simulated pace updates...');

    let requestInfo: geoLocationManager.LocationRequest = {
      'priority': 0x203,
      'scenario': 0x300,
      'timeInterval': 1000,
      'distanceInterval': 1,
      'maxAccuracy': 0
    }
    try {
      geoLocationManager.on('locationChange', requestInfo, (loc: geoLocationManager.Location) => {
        if (loc && loc.latitude !== 0 && loc.longitude !== 0) {
          this.calculatePace(loc);
        }
      });
    } catch (err) {
      console.error('[PM] Startup Error:', JSON.stringify(err));
    }
  }

  private static stop() {
    try {
      geoLocationManager.off('locationChange');
      this.locationRequestId = null;
      this.lastLocation = null; // Reset last location data
      this.paceMonitor = 0; // Reset pace
      console.info('[PM]', 'Pace monitoring stopped and resources reset');
      console.info('[PM]', 'Pace monitoring stopped');
    } catch (e) {
      console.error('[PM] Stop Error:', JSON.stringify(e));
    }
  }

  private static format(p: number): string {
    if (p <= 0) return "--:--";

    const paceDecimal = 1000 / (p * 60);

    // Handle infinity/errors
    if (!isFinite(paceDecimal) || paceDecimal > 30) return "--:--";
    const minutes = Math.floor(paceDecimal);
    const seconds = Math.round((paceDecimal - minutes) * 60);
    const secondsStr = seconds < 10 ? `0${seconds}` : `${seconds}`;
    return `${minutes}:${secondsStr}`;
  }

  // Optional: Get one-time data
  static once(cb: PMListener) {
    // 1. Define the required SingleLocationRequest object
    const singleRequest: geoLocationManager.SingleLocationRequest = {
      // Use a high-accuracy priority for the best initial speed reading
      'locatingPriority': geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED,
      'locatingTimeoutMs': 10000
    };

    // 2. Call getCurrentLocation with the request object AND the callback.
    // The callback must accept both error and result arguments, following the
    // standard HarmonyOS AsynchronousCallback signature (err, result).
    geoLocationManager.getCurrentLocation(singleRequest, (err: BusinessError, loc: geoLocationManager.Location) => {
      if (err) {
        console.error('[PM] GetOnce Error:', JSON.stringify(err));
        // On error, return current stored or zero pace
        cb(this.paceMonitor, this.format(this.paceMonitor));
        return;
      }

      // Use reported speed if available, otherwise 0
      const currentPace = loc?.speed || 0;
      this.paceMonitor = currentPace;
      const formattedPace = this.format(currentPace);

      cb(currentPace, formattedPace);
      console.info('[PM]', `One-time pace (from location speed) -> ${currentPace.toFixed(2)} m/s, ${formattedPace}`);
    });
  }
}