import sensor from '@ohos.sensor';
import { common } from '@kit.AbilityKit';
import { HeartRateStorage } from '../data/HeartRateStorage';
import { HeartRateRecord } from '../data/HeartRateRecord';
import { HeartRateData } from '../data/HeartRateData';

export class HeartRateService {
  private storage: HeartRateStorage = new HeartRateStorage();
  private isRunning: boolean = false;

  // Start monitoring
  start(context: common.BaseContext): void {
    this.storage.init(context);
    this.isRunning = true;

    const sensorId = sensor.SensorId.HEART_RATE;
    if (sensorId === undefined) {
      console.error('Heart rate sensor not available');
      return;
    }

    sensor.on(
      sensorId,
      async (data: HeartRateData) => {
        if (data.bpm !== undefined) {
          const timestamp: number = data.timestamp ?? Date.now();
          const record = new HeartRateRecord(timestamp, data.bpm);
          await this.storage.addRecord(record);
        }
      },
      { interval: 1_000_000_000 } // 1 second
    );
  }

  // Stop monitoring
  stop(): void {
    const sensorId = sensor.SensorId.HEART_RATE;
    if (sensorId !== undefined && this.isRunning) {
      sensor.off(sensorId);
      this.isRunning = false;
    }
  }
}
