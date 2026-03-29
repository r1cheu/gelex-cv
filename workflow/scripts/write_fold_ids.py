import sys

import pandas as pd

assignment = pd.read_csv(snakemake.input.assignment, sep="\t", dtype=str)
assignment["fold"] = assignment["fold"].astype(int)
fold = snakemake.params.fold

with open(snakemake.log[0], "w") as log:
    sys.stderr = log

    test_mask = assignment["fold"] == fold
    test = assignment.loc[test_mask, ["FID", "IID"]]
    train = assignment.loc[~test_mask, ["FID", "IID"]]

    train.to_csv(snakemake.output.train_ids, sep="\t", index=False, header=False)
    test.to_csv(snakemake.output.test_ids, sep="\t", index=False, header=False)
    print(f"Fold {fold}: train={len(train)}, test={len(test)}", file=log)
