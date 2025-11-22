export class HeartRateRecord {
  timestamp: number;
  bpm: number;

  constructor(timestamp: number, bpm: number) {
    this.timestamp = timestamp;
    this.bpm = bpm;
  }

  timestampAsString(): string {
    return this.timestamp.toString();
  }

  bpmAsString(): string {
    return this.bpm.toString();
  }
}
