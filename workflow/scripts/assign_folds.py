import sys

import numpy as np
import pandas as pd

fam_path = snakemake.input.fam
kfold = snakemake.params.kfold
seed = snakemake.params.seed
out_path = snakemake.output.assignment

with open(snakemake.log[0], "w") as log:
    sys.stderr = log

    fam = pd.read_csv(
        fam_path, sep=r"\s+", header=None, usecols=[0, 1], names=["FID", "IID"], dtype=str
    )
    n = len(fam)
    rng = np.random.default_rng(seed)
    fam["fold"] = rng.permutation(np.tile(np.arange(kfold), n // kfold + 1)[:n])
    fam.to_csv(out_path, sep="\t", index=False)
    print(f"Assigned {n} samples to {kfold} folds", file=log)
