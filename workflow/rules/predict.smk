rule gelex_predict:
    input:
        bed=results("fold_{fold}/test.bed"),
        bim=results("fold_{fold}/test.bim"),
        fam=results("fold_{fold}/test.fam"),
        snp_eff=results("{phenotype}/fold_{fold}/{phenotype}.snp.eff"),
        sbin=results("{phenotype}/fold_{fold}/{phenotype}.sbin"),
        param=results("{phenotype}/fold_{fold}/{phenotype}.param"),
    output:
        pred=temp(results("{phenotype}/fold_{fold}/predictions.tsv")),
    params:
        bfile=lambda wc: results(f"fold_{wc.fold}/test"),
        gfile=lambda wc: results(f"{wc.phenotype}/fold_{wc.fold}/{wc.phenotype}"),
        extra=get_optional_predict_flags(),
    shell:
        GELEX_PREDICT_CMD
