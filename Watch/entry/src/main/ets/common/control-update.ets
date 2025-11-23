
// control-update.ets

/**
 * Computes the next control vector u based on the previous one.
 * Replace the logic below with your actual control update model.
 */
export function nextU(uPrev: number[]): number[] {
  const uNext: number[] = new Array(uPrev.length);

  uNext[0] = uPrev[0] + 3/40
  uNext[1] = uNext[0] *  uNext[0]
  uNext[2] = uPrev[2]

  return uNext;
}

export function CreateU(uPrev: number[]): number[] {
  const uCreate: number[] = new Array(uPrev.length + 1);

  uCreate[0] = uPrev[0]
  uCreate[1] = uCreate[0] * uCreate[0]
  uCreate[2] = uPrev[1]

  return uCreate;
}
