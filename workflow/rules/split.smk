rule assign_folds:
    input:
        fam=config["bfile"] + ".fam",
    output:
        assignment=results("folds/fold_assignment.tsv"),
    params:
        kfold=K,
        seed=config.get("seed", 42),
    log:
        results("logs/assign_folds.log"),
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/assign_folds.py"


rule write_fold_ids:
    input:
        assignment=results("folds/fold_assignment.tsv"),
    output:
        train_ids=temp(results("fold_{fold}/train_ids.txt")),
        test_ids=temp(results("fold_{fold}/test_ids.txt")),
    params:
        fold=lambda wc: int(wc.fold),
    log:
        results("logs/write_fold_ids_{fold}.log"),
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/write_fold_ids.py"
