import { sensor } from '@kit.SensorServiceKit';

interface PaceResponse {
  paceMonitor?: number;
  value?: number;
}

type PMListener = (pm: number, ps: string) => void;

export default class PaceMonitor {
  // simulated data in m/s
    private static SIMULATED_PACE: number[] = [
      2.0, 2.5, 3.0, 3.5, 4.0, 4.2, 4.4, 4.6, 4.8, 5.0, 5.2, 5.1, 5.0, 4.9, 4.8,
      4.5, 4.0, 3.5, 3.0, 2.0,
  ];
  private static currentDataIndex: number = 0; // Index for the array
  private static intervalId: number | null = null; // To store the interval timer ID

  private static paceMonitor = 0;
  private static listeners = new Set<PMListener>();

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

  private static start() {
    console.info('[PM]', 'Starting simulated pace updates...');

    // Use setInterval to update the HR every 1000 milliseconds (1 second)
    this.intervalId = setInterval(() => {
      // Get the next heart rate value from the array
      const pm: number =
        this.SIMULATED_PACE[this.currentDataIndex];

      // Update the class variable
      this.paceMonitor = pm;

      // Notify all subscribers
      this.listeners.forEach((fn) => fn(pm, this.format(pm)));
      console.info('[HR]', `Simulated pace update -> ${pm}`);

      // 3. Move to the next index and loop back to the start if the end is reached
      this.currentDataIndex =
        (this.currentDataIndex + 1) % this.SIMULATED_PACE.length;
    }, 1000); // Update every 1000ms (1 second)
  }

  private static stop() {
    if (this.intervalId !== null) {
      clearInterval(this.intervalId);
      this.intervalId = null;
      console.info('[HR]', 'Simulated heart rate sensor stopped');
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
    cb(this.paceMonitor, this.format(this.paceMonitor));
    console.info('[HR]', `One-time simulated heart rate -> ${this.paceMonitor}`);
  }
}