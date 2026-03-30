import sys

import pandas as pd

with open(snakemake.log[0], "w") as log:
    sys.stderr = log

    dfs = []
    for path, pheno_col in zip(snakemake.input.evals, snakemake.params.pheno_cols):
        df = pd.read_csv(path, sep="\t")
        df["pheno_col"] = pheno_col
        dfs.append(df)

    summary = pd.concat(dfs, ignore_index=True)
    summary.to_csv(snakemake.output.summary, sep="\t", index=False)
    print(f"Summary across {len(dfs)} phenotypes", file=log)
