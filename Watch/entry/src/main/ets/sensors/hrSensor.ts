import { sensor } from '@kit.SensorServiceKit';

interface HeartRateResponse {
  heartRate?: number;
  value?: number;
}

type HRListener = (hr: number) => void;

export default class HeartRateSensor {
  private static heartRate = 0;
  private static listeners = new Set<HRListener>();

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
    try {
      sensor.on(sensor.SensorId.HEART_RATE, (data: sensor.HeartRateResponse) => {
        const hr: number = (data as HeartRateResponse).heartRate
          ?? (data as HeartRateResponse).value
          ?? 0;
        if (typeof hr === 'number') {
          this.heartRate = hr;
          // Notify all subscribers
          this.listeners.forEach(fn => fn(hr));
          console.info('[HR]', `Heart rate updates -> ${hr}`);
        }
      });
    } catch (err) {
      console.error('[HR] Startup Error:', JSON.stringify(err));
    }
  }

  private static stop() {
    try {
      sensor.off(sensor.SensorId.HEART_RATE);
      console.info('[HR]', 'Heart rate sensor stopped');
    } catch (e) {
      console.error('[HR] Startup Error:', JSON.stringify(e));
    }
  }

  // Optional: Get one-time data
  static once(cb: HRListener) {
    sensor.once(sensor.SensorId.HEART_RATE, (data: sensor.HeartRateResponse) => {
      const hr: number = (data as HeartRateResponse).heartRate
        ?? (data as HeartRateResponse).value
        ?? 0;
      if (typeof hr === 'number') {
        this.heartRate = hr;
        cb(hr);
        console.info('[HR]', `One-time heart rate -> ${hr}`);
      }
    });
  }
}