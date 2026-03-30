rule gelex_predict:
    input:
        bed=results("fold_{fold}/test.bed"),
        bim=results("fold_{fold}/test.bim"),
        fam=results("fold_{fold}/test.fam"),
        snp_eff=results("pheno_{pheno_col}/fold_{fold}/model.snp.eff"),
        sbin=results("pheno_{pheno_col}/fold_{fold}/model.sbin"),
        param=results("pheno_{pheno_col}/fold_{fold}/model.param"),
    output:
        pred=temp(results("pheno_{pheno_col}/fold_{fold}/predictions.tsv")),
    params:
        bfile=lambda wc: results(f"fold_{wc.fold}/test"),
        gfile=lambda wc: results(f"pheno_{wc.pheno_col}/fold_{wc.fold}/model"),
        extra=get_optional_predict_flags(),
    shell:
        GELEX_PREDICT_CMD
