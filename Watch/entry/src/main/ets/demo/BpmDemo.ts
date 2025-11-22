import { sensor } from '@kit.SensorServiceKit';

interface HeartRateResponse {
  heartRate?: number;
  value?: number;
}

type HRListener = (hr: number) => void;

export default class HeartRateSensor {
  private static SIMULATED_HEART_RATES: number[] = [
    105, 110, 118, 125, 133, 138, 142, 145, 148, 152, 155, 154, 153, 151, 149,
    145, 140, 135, 128, 115,
  ];
  private static currentDataIndex: number = 0; // Index for the array
  private static intervalId: number | null = null; // To store the interval timer ID

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