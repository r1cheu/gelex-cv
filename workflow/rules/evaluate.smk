rule merge_predictions:
    input:
        preds=lambda wc: expand(
            results("pheno_{pheno_col}/fold_{fold}/predictions.tsv"),
            fold=FOLDS,
            pheno_col=wc.pheno_col,
        ),
    output:
        merged=results("pheno_{pheno_col}/merged_predictions.tsv"),
    log:
        results("logs/merge_predictions_pheno_{pheno_col}.log"),
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/merge_predictions.py"


rule evaluate:
    input:
        merged=results("pheno_{pheno_col}/merged_predictions.tsv"),
        pheno=config["pheno"],
    output:
        evaluation=results("pheno_{pheno_col}/evaluation.tsv"),
    params:
        pheno_col=lambda wc: int(wc.pheno_col),
    log:
        results("logs/evaluate_pheno_{pheno_col}.log"),
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/evaluate.py"


rule summary:
    input:
        evals=expand(results("pheno_{pheno_col}/evaluation.tsv"), pheno_col=PHENO_COLS),
    output:
        summary=results("summary.tsv"),
    params:
        pheno_cols=PHENO_COLS,
    log:
        results("logs/summary.log"),
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/summary.py"
