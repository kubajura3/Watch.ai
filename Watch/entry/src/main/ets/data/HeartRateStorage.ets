import { preferences } from '@kit.ArkData';
import { HeartRateRecord } from './HeartRateRecord';
import { common } from '@kit.AbilityKit';

/**
 * Defines the plain object structure used for storing heart rate data in Preferences.
 */
export interface StoredHeartRateData {
  timestamp: number;
  bpm: number;
}

export class HeartRateStorage {
  private prefs!: preferences.Preferences;
  private readonly KEY_HISTORY: string = 'records';

  /**
   * Initialize storage with BaseContext
   */
  init(context: common.BaseContext): void {
    const opts: preferences.Options = { name: 'heart_rate_history' };
    this.prefs = preferences.getPreferencesSync(context, opts);
  }

  async addRecord(record: HeartRateRecord): Promise<void> {
    const historyJson: string = String(await this.prefs.get(this.KEY_HISTORY, '[]'));
    const parsedArray: StoredHeartRateData[] = JSON.parse(historyJson);

    const records: HeartRateRecord[] = [];
    for (let i = 0; i < parsedArray.length; i++) {
      const item = parsedArray[i];
      records.push(new HeartRateRecord(Number(item.timestamp), Number(item.bpm)));
    }

    records.push(record);

    // FIX: Changed <T>{} to ({}) as T for ArkTS compatibility.
    // The object literal is now explicitly typed using 'as StoredHeartRateData'.
    const recordsToStore: StoredHeartRateData[] = records.map(r => ({
      timestamp: r.timestamp,
      bpm: r.bpm
    }) as StoredHeartRateData);

    await this.prefs.put(this.KEY_HISTORY, JSON.stringify(recordsToStore));
    await this.prefs.flush();
  }

  async getHistory(): Promise<HeartRateRecord[]> {
    const historyJson: string = String(await this.prefs.get(this.KEY_HISTORY, '[]'));
    const parsedArray: StoredHeartRateData[] = JSON.parse(historyJson);

    const records: HeartRateRecord[] = [];
    for (let i = 0; i < parsedArray.length; i++) {
      const item = parsedArray[i];
      records.push(new HeartRateRecord(Number(item.timestamp), Number(item.bpm)));
    }

    return records;
  }

  async clear(): Promise<void> {
    await this.prefs.put(this.KEY_HISTORY, '[]');
    await this.prefs.flush();
  }
}