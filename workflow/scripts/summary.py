import sys

import pandas as pd

with open(snakemake.log[0], "w") as log:
    sys.stderr = log

    dfs = []
    for path, phenotype in zip(snakemake.input.evals, snakemake.params.phenotypes):
        df = pd.read_csv(path, sep="\t")
        df["phenotype"] = phenotype
        dfs.append(df)

    summary = pd.concat(dfs, ignore_index=True)
    summary.to_csv(snakemake.output.summary, sep="\t", index=False)
    print(f"Summary across {len(dfs)} phenotypes", file=log)
