export class KalmanFilter {
  private x: number;      // State (scalar)
  private P: number;      // Covariance (scalar)

  private readonly F: number;
  private readonly Q: number;
  private readonly H: number;
  private readonly R: number;

  private readonly B: Array<number>; // Control vector

  constructor(
    initialX: number,
    initialP: number,
    F: number,
    Q: number,
    H: number,
    R: number,
    B: Array<number>  // vector
  ) {
    this.x = initialX;
    this.P = initialP;

    this.F = F;
    this.Q = Q;
    this.H = H;
    this.R = R;

    this.B = B;
  }

  // -----------------------------------------
  //   PREDICT ONLY — uses control vector u[]
  // -----------------------------------------
  public predictOnly(u: Array<number>): number {
    if (u.length !== this.B.length) {
      throw new Error("Control vector u must have same length as B");
    }

    let controlEffect: number = 0;
    for (let i = 0; i < u.length; i++) {
      controlEffect += this.B[i] * u[i];
    }

    this.x = this.F * this.x + controlEffect;
    this.P = this.F * this.P * this.F + this.Q;

    return this.x;
  }

  // ------------------------------------------------------
  //   FULL KALMAN STEP — prediction + measurement update
  // ------------------------------------------------------
  public predictAndUpdate(measurement: number, u: Array<number>): number {
    if (u.length !== this.B.length) {
      throw new Error("Control vector u must have same length as B");
    }

    let controlEffect: number = 0;
    for (let i = 0; i < u.length; i++) {
      controlEffect += this.B[i] * u[i];
    }

    // Predict
    this.x = this.F * this.x + controlEffect;
    this.P = this.F * this.P * this.F + this.Q;

    // Innovation
    const y: number = measurement - this.H * this.x;
    const S: number = this.H * this.P * this.H + this.R;
    const K: number = (this.P * this.H) / S;

    // Update
    this.x = this.x + K * y;
    this.P = (1 - K * this.H) * this.P;

    return this.x;
  }

  public getState(): number {
    return this.x;
  }

  public getCovariance(): number {
    return this.P;
  }

  public clone(): KalmanFilter {
    return new KalmanFilter(
      this.x,
      this.P,
      this.F,
      this.Q,
      this.H,
      this.R,
      [...this.B]
    );
  }
}
