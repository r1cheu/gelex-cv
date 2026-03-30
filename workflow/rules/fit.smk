rule gelex_fit:
    input:
        bed=results("fold_{fold}/train.bed"),
        bim=results("fold_{fold}/train.bim"),
        fam=results("fold_{fold}/train.fam"),
        pheno=config["pheno"],
    output:
        snp_eff=results("pheno_{pheno_col}/fold_{fold}/model.snp.eff"),
        sbin=results("pheno_{pheno_col}/fold_{fold}/model.sbin"),
        param=results("pheno_{pheno_col}/fold_{fold}/model.param"),
    params:
        pheno_col=lambda wc: wc.pheno_col,
        **fit_params(
            bfile_fn=lambda wc: results(f"fold_{wc.fold}/train"),
            out_fn=lambda wc: results(f"pheno_{wc.pheno_col}/fold_{wc.fold}/model"),
        ),
    threads: config.get("threads", 4)
    shell:
        GELEX_FIT_CMD
