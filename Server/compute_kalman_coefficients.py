import numpy as np
from dataclasses import dataclass


@dataclass
class StateDynamics:
    """
    Represents the dynamical model:
        x_k = A * x_{k-1} + B^T * u_{k-1} + w_{k-1}
    where w_{k-1} ~ N(0, Q)
    """
    A: float
    B: np.ndarray
    Q: float


def fit_state_dynamics_with_fixed_A(
    x: np.ndarray,
    u: np.ndarray,
    A: float
) -> StateDynamics:
    """
    Fit the linear dynamical model with fixed A:
        x_k = A * x_{k-1} + B^T u_{k-1} + w_{k-1}

    Parameters
    ----------
    x : np.ndarray (N,)
        State sequence.
    u : np.ndarray (N, k)
        Input sequence.
    A : float
        Fixed scalar A (not estimated).

    Returns
    -------
    StateDynamics
        Object containing A, B, and Q.
    """

    if x.ndim != 1:
        raise ValueError("x must be a 1D array of shape (N,)")

    if u.ndim != 2:
        raise ValueError("u must be a 2D array of shape (N, k)")

    if len(x) != len(u):
        raise ValueError("x and u must have the same number of rows")

    # Split time-aligned sequences
    x_prev = x[:-1]    # (N-1,)
    x_next = x[1:]     # (N-1,)
    u_prev = u[:-1, :] # (N-1, k)

    # Compute y_k = x_k - A x_{k-1}
    y = x_next - A * x_prev   # (N-1,)

    # Solve for B using least squares on:
    # y = u_prev @ B
    B, _, _, _ = np.linalg.lstsq(u_prev, y, rcond=None)

    # Compute process noise variance Q
    residuals = y - u_prev @ B
    # Degrees of freedom = number of parameters estimated
    dof = len(B)
    Q = float(np.var(residuals, ddof=dof))

    return StateDynamics(A=A, B=B, Q=Q)
