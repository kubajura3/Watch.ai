
// update-and-predict.ets

import { KalmanFilter } from './KalmanFilter';
import { nextU } from './control-update';

export interface UpdateAndPredictResult {
  stateNow: number;      // updated real-time state (after measurement)
  uNext: number[];       // control vector for next real-time step
  predictedState: number; // predicted state k steps ahead (does NOT change filter)
}

/**
 * Performs:
 *  1) predict + update with measurement   --> REAL filter change
 *  2) compute next control vector uNext   --> for next real-time iteration
 *  3) simulate k steps ahead (no measurement) on a CLONED filter
 */
export function updateAndPredictAhead(
  filter: KalmanFilter,
  measurement: number,
  u: number[],
  k: number
): UpdateAndPredictResult {

  if (k < 0) {
    throw new Error("k must be >= 0");
  }

  if (measurement === undefined || Number.isNaN(measurement)) {
    throw new Error("Invalid measurement");
  }

  // -----------------------------
  // STEP 1 — REAL UPDATE
  // -----------------------------
  filter.predictAndUpdate(measurement, u);

  const stateNow = filter.getState();

  // -----------------------------
  // STEP 2 — NEXT CONTROL VECTOR
  // -----------------------------
  const uNext = nextU(u);

  // -----------------------------
  // STEP 3 — PREDICT AHEAD (k steps)
  // Using a cloned filter so the real filter is NOT modified.
  // -----------------------------
  const cloned = filter.clone();   // <--- You need to implement clone() in KalmanFilter

  let uSim = [...uNext];           // start with next-step control
  for (let i = 0; i < k; i++) {
    cloned.predictOnly(uSim);
    uSim = nextU(uSim);
  }

  const predictedState = cloned.getState();

  // -----------------------------
  // RETURN RESULTS
  // -----------------------------
  return {
    stateNow,
    uNext,
    predictedState
  };
}
