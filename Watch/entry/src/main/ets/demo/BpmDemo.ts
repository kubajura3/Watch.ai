import { sensor } from '@kit.SensorServiceKit';

interface HeartRateResponse {
  heartRate?: number;
  value?: number;
}

type HRListener = (hr: number) => void;

export default class HeartRateSensor {
  private static SIMULATED_HEART_RATES: number[] = [
    120.87088649, 119.56604084, 118.18470666, 119.08824089, 116.98393686,
    116.26977488, 115.84168155, 116.19759025, 115.92650918, 117.10986016,
    119.12074682, 118.58151864, 121.73191925, 123.70147721, 126.89979524,
    139.36716658, 139.89609063, 142.24344847, 142.47492025, 148.07672121,
    155.6533313, 163.02035652, 165.92070833, 169.08700875, 169.65257509,
    174.93149448, 176.71492319, 177.35332565, 176.36761763, 177.73800875,
    177.83527021, 178.15248512, 178.55947325, 177.43417152, 177.35421898,
    177.40699156, 175.99930226, 176.16420041, 174.2784753, 172.40384581,
    169.44671582, 167.71193042, 166.15178312, 165.49934801, 161.88408324,
    161.72787041, 159.84594803, 154.05130013, 152.73942634, 147.89577601,
    147.9299277, 146.7075567, 140.20766621, 135.7206995, 134.55117412,
    135.09564504, 132.61079001, 128.87568065, 128.29802205, 127.47877094,
    126.27656759, 127.60553911, 127.29643011, 127.59197809, 130.91474012,
    131.99008519, 133.42472675, 133.07473051, 133.82194429, 134.35829621,
    134.41945457, 135.16568126, 134.80451812, 136.72607755, 136.67147612,
    137.43932915, 136.78522146, 137.15282782, 138.50187864, 139.84386764,
    140.31946699, 142.48232748, 150.11747473, 155.45782062, 160.12405812,
    162.16150809, 164.53364974, 170.16029056, 172.94267434, 171.45747852,
    165.77101871, 160.35348053, 155.7335636, 147.59214433, 135.50488861,
  ];
  private static currentDataIndex: number = 0; // Index for the array
  private static intervalId: number | null = null; // To store the interval timer ID

  private static heartRate = 0;
  private static listeners = new Set<HRListener>();

  static getHeartRateMean(): number {
    if (this.SIMULATED_HEART_RATES.length === 0) {
      console.warn('[HR]', 'Heart rate array is empty, returning 0');
      return 0;
    }

    const sum = this.SIMULATED_HEART_RATES.reduce((accumulator, currentValue) => {
      return accumulator + currentValue;
    }, 0);

    const mean = sum / this.SIMULATED_HEART_RATES.length;
    return mean;
  }

  // Component subscribes to heart rate changes
  static subscribe(cb: HRListener) {
    this.listeners.add(cb);
    // Start the sensor the first time someone subscribes
    if (this.listeners.size === 1) this.start();
    // Returns the current value immediately (optional)
    cb(this.heartRate);
  }

  // Unsubscribe
  static unsubscribe(cb: HRListener) {
    this.listeners.delete(cb);
    // Stop the sensor if no one is listening
    if (this.listeners.size === 0) this.stop();
  }

  private static start() {
    console.info('[HR]', 'Starting simulated heart rate updates...');

    // Use setInterval to update the HR every 1000 milliseconds (1 second)
    this.intervalId = setInterval(() => {
      // Get the next heart rate value from the array
      const hr: number =
        this.SIMULATED_HEART_RATES[this.currentDataIndex];

      // Update the class variable
      this.heartRate = hr;

      // Notify all subscribers
      this.listeners.forEach((fn) => fn(hr));
      console.info('[HR]', `Simulated heart rate update -> ${hr}`);

      // 3. Move to the next index and loop back to the start if the end is reached
      this.currentDataIndex =
        (this.currentDataIndex + 1) % this.SIMULATED_HEART_RATES.length;
    }, 1000); // Update every 1000ms (1 second)
  }

  private static stop() {
    if (this.intervalId !== null) {
      clearInterval(this.intervalId);
      this.intervalId = null;
      console.info('[HR]', 'Simulated heart rate sensor stopped');
    }
  }

  // Optional: Get one-time data
  static once(cb: HRListener) {
    cb(this.heartRate);
    console.info('[HR]', `One-time simulated heart rate -> ${this.heartRate}`);
  }
}