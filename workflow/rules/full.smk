rule full_fit:
    input:
        **bfile_inputs(config["bfile"]),
        pheno=config["pheno"],
    output:
        snp_eff=results("pheno_{pheno_col}/model.snp.eff"),
        sbin=results("pheno_{pheno_col}/model.sbin"),
        param=results("pheno_{pheno_col}/model.param"),
    params:
        pheno_col=lambda wc: wc.pheno_col,
        **fit_params(
            bfile_fn=config["bfile"],
            out_fn=lambda wc: results(f"pheno_{wc.pheno_col}/model"),
        ),
    threads: config.get("threads", 4)
    shell:
        GELEX_FIT_CMD


rule full_predict:
    input:
        **bfile_inputs(config["bfile"]),
        snp_eff=results("pheno_{pheno_col}/model.snp.eff"),
        sbin=results("pheno_{pheno_col}/model.sbin"),
        param=results("pheno_{pheno_col}/model.param"),
    output:
        pred=results("pheno_{pheno_col}/predictions.tsv"),
    params:
        bfile=config["bfile"],
        gfile=lambda wc: results(f"pheno_{wc.pheno_col}/model"),
        extra=get_optional_predict_flags(),
    shell:
        GELEX_PREDICT_CMD
