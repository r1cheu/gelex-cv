import sys

import pandas as pd

with open(snakemake.log[0], "w") as log:
    sys.stderr = log

    dfs = []
    for path in snakemake.input.preds:
        df = pd.read_csv(path, sep="\t", dtype={"FID": str, "IID": str})
        dfs.append(df)

    merged = pd.concat(dfs, ignore_index=True)
    merged.to_csv(snakemake.output.merged, sep="\t", index=False)
    print(f"Merged {len(merged)} predictions from {len(dfs)} folds", file=log)
