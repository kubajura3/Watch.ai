export class HeartRateData {
  bpm?: number;
  timestamp?: number;

  constructor(bpm?: number, timestamp?: number) {
    this.bpm = bpm;
    this.timestamp = timestamp;
  }
}
