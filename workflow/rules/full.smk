rule full_fit:
    input:
        **bfile_inputs(config["bfile"]),
        pheno=config["pheno"],
    output:
        snp_eff=results("{phenotype}/{phenotype}.snp.eff"),
        sbin=results("{phenotype}/{phenotype}.sbin"),
        param=results("{phenotype}/{phenotype}.param"),
    params:
        pheno_col=lambda wc: PHENO_TO_COL[wc.phenotype],
        **fit_params(
            bfile_fn=config["bfile"],
            out_fn=lambda wc: results(f"{wc.phenotype}/{wc.phenotype}"),
        ),
    threads: config.get("threads", 4)
    shell:
        GELEX_FIT_CMD


rule full_predict:
    input:
        **bfile_inputs(config["bfile"]),
        snp_eff=results("{phenotype}/{phenotype}.snp.eff"),
        sbin=results("{phenotype}/{phenotype}.sbin"),
        param=results("{phenotype}/{phenotype}.param"),
    output:
        pred=results("{phenotype}/predictions.tsv"),
    params:
        bfile=config["bfile"],
        gfile=lambda wc: results(f"{wc.phenotype}/{wc.phenotype}"),
        extra=get_optional_predict_flags(),
    shell:
        GELEX_PREDICT_CMD
