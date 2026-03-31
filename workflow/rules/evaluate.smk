rule merge_predictions:
    input:
        preds=lambda wc: expand(
            results("{phenotype}/fold_{fold}/predictions.tsv"),
            fold=FOLDS,
            phenotype=wc.phenotype,
        ),
    output:
        merged=results("{phenotype}/merged_predictions.tsv"),
    log:
        results("logs/merge_predictions_{phenotype}.log"),
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/merge_predictions.py"


rule evaluate:
    input:
        merged=results("{phenotype}/merged_predictions.tsv"),
        pheno=config["pheno"],
    output:
        evaluation=results("{phenotype}/evaluation.tsv"),
    params:
        phenotype=lambda wc: wc.phenotype,
    log:
        results("logs/evaluate_{phenotype}.log"),
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/evaluate.py"


rule summary:
    input:
        evals=expand(results("{phenotype}/evaluation.tsv"), phenotype=PHENOTYPES),
    output:
        summary=results("summary.tsv"),
    params:
        phenotypes=PHENOTYPES,
    log:
        results("logs/summary.log"),
    conda:
        "../envs/pandas.yaml"
    script:
        "../scripts/summary.py"
