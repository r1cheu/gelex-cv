rule merge_predictions:
    input:
        preds=expand(results("fold_{fold}/predictions.tsv"), fold=FOLDS),
    output:
        merged=results("merged_predictions.tsv"),
    log:
        results("logs/merge_predictions.log"),
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/merge_predictions.py"


rule evaluate:
    input:
        merged=results("merged_predictions.tsv"),
        pheno=config["pheno"],
    output:
        evaluation=results("evaluation.tsv"),
    params:
        pheno_col=config.get("pheno_col", 2),
    log:
        results("logs/evaluate.log"),
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/evaluate.py"
