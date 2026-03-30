import sys

import numpy as np
import pandas as pd

with open(snakemake.log[0], "w") as log:
    sys.stderr = log

    pheno_col = snakemake.params.pheno_col

    pred = pd.read_csv(snakemake.input.merged, sep="\t", dtype={"FID": str, "IID": str})
    pheno_all_cols = pd.read_csv(snakemake.input.pheno, sep="\t", nrows=0).columns.tolist()
    trait_col = pheno_all_cols[pheno_col]
    pheno = pd.read_csv(
        snakemake.input.pheno, sep="\t", usecols=["FID", "IID", trait_col],
        dtype={"FID": str, "IID": str},
    )

    merged = pred.merge(pheno, on=["FID", "IID"])

    pred_cols = [c for c in pred.columns if c not in ("FID", "IID")]
    pred_col = pred_cols[0]

    valid = merged.dropna(subset=[trait_col, pred_col])
    y_true = valid[trait_col].astype(float)
    y_pred = valid[pred_col].astype(float)

    cor = np.corrcoef(y_true, y_pred)[0, 1]
    mse = float(np.mean((y_true - y_pred) ** 2))
    n = len(valid)

    results = pd.DataFrame(
        {"metric": ["pearson_r", "mse", "n_samples"], "value": [cor, mse, n]}
    )
    results.to_csv(snakemake.output.evaluation, sep="\t", index=False)
    print(f"Correlation: {cor:.4f}, MSE: {mse:.4f}, N: {n}", file=log)
