import pandas as pd
import numpy as np
from typing import Callable, Dict, List, Union


class FeatureFactory:
    """
    A flexible feature generator for nonlinear column transformations.
    
    Example usage:
        ff = FeatureFactory()
        ff.add_transformation("square", lambda x: x**2)
        ff.add_transformation("log1p", np.log1p)

        df_new = ff.transform(df, columns=["col1", "col2"])
    """

    def __init__(self):
        # Dictionary storing transformation_name -> transformation_function
        self.transformations: Dict[str, Callable[[pd.Series], pd.Series]] = {}

    def add_transformation(self, name: str, func: Callable[[pd.Series], pd.Series]):
        """
        Register a new transformation.
        """
        if not callable(func):
            raise ValueError("Transformation must be a callable.")
        self.transformations[name] = func

    def remove_transformation(self, name: str):
        """
        Remove a transformation by name.
        """
        if name in self.transformations:
            del self.transformations[name]

    def list_transformations(self) -> List[str]:
        """
        Return the list of available transformation names.
        """
        return list(self.transformations.keys())

    def transform(
        self,
        df: pd.DataFrame,
        columns: List[str],
        transformations: Union[str, List[str], None] = None,
        suffix: bool = True,
        inplace: bool = False
    ) -> pd.DataFrame:
        """
        Apply selected transformations to selected columns.

        Parameters
        ----------
        df : pd.DataFrame
        columns : list of columns to transform
        transformations : list of transformation names or 
                          None = apply all registered transformations
        suffix : if True → new columns get suffix like "_square"
        inplace : modify original DataFrame

        Returns
        -------
        new_df : pd.DataFrame with additional transformed columns
        """
        if not inplace:
            df = df.copy()

        if transformations is None:
            transformations = list(self.transformations.keys())
        if isinstance(transformations, str):
            transformations = [transformations]

        for col in columns:
            if col not in df.columns:
                raise KeyError(f"Column '{col}' not found in DataFrame.")

            for t in transformations:
                if t not in self.transformations:
                    raise KeyError(f"Transformation '{t}' is not registered.")

                new_col_name = f"{col}_{t}" if suffix else t
                df[new_col_name] = self.transformations[t](df[col])

        return df
    
import pandas as pd

'''
# Sample data
df = pd.DataFrame({
    "x": [1, 2, 3, 4],
    "y": [10, 20, 30, 40]
})

# Create factory
ff = FeatureFactory()

# Add transformations
ff.add_transformation("square", lambda x: x ** 2)
ff.add_transformation("cube", lambda x: x ** 3)
ff.add_transformation("sin", np.sin)
ff.add_transformation("exp", np.exp)

# Generate nonlinear features
df_new = ff.transform(df, columns=["x", "y"])

print(df_new)   '''