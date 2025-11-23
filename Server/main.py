from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import pandas as pd
from feature_factory import FeatureFactory
import numpy as np
from compute_kalman_coefficients import fit_state_dynamics_with_fixed_A

app = FastAPI()


# ----- Pydantic models -----
class Item(BaseModel):
    timestamp: str
    bpm: str

class InputData(BaseModel):
    data: List[Item]


# ----- API endpoint -----
@app.post("/process")
def process(input_data: InputData):
    # 1. Convert pydantic objects to list of dicts
    raw_list = [item.dict() for item in input_data.data]

    # 2. Create DataFrame
    df = pd.DataFrame(raw_list)

    # 3. Convert fields to numeric
    df["timestamp"] = pd.to_numeric(df["timestamp"])
    df["bpm"] = pd.to_numeric(df["bpm"])

    # 4. Sort by timestamp
    df = df.sort_values("timestamp")



        # Create factory
    ff = FeatureFactory()

    # Add transformations
    ff.add_transformation("square", lambda x: x ** 2)
    ff.add_transformation("cube", lambda x: x ** 3)
    ff.add_transformation("sin", np.sin)
    ff.add_transformation("exp", np.exp)

    # Generate nonlinear features
    df_new = ff.transform(df, columns=["timestamp", "bpm", "pace"])

    col = "bpm"
    df = df[[col] + [c for c in df.columns if c != col]]


    x = df.iloc[:, 0].values           # kolumna x (shape: N,)
    u = df.iloc[:, 1:].values          # reszta kolumn jako u (shape: N, k)

    # --- Stała wartość A ---
    A_fixed = 0.95

    # --- Użycie Twojej funkcji ---
    result = fit_state_dynamics_with_fixed_A(
        x=x,
        u=u,
        A=A_fixed
    )

    return {result.B, result.Q}