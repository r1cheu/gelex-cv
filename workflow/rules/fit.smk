rule gelex_fit:
    input:
        bed=results("fold_{fold}/train.bed"),
        bim=results("fold_{fold}/train.bim"),
        fam=results("fold_{fold}/train.fam"),
        pheno=config["pheno"],
    output:
        snp_eff=results("{phenotype}/fold_{fold}/{phenotype}.snp.eff"),
        sbin=results("{phenotype}/fold_{fold}/{phenotype}.sbin"),
        param=results("{phenotype}/fold_{fold}/{phenotype}.param"),
    params:
        pheno_col=lambda wc: PHENO_TO_COL[wc.phenotype],
        **fit_params(
            bfile_fn=lambda wc: results(f"fold_{wc.fold}/train"),
            out_fn=lambda wc: results(f"{wc.phenotype}/fold_{wc.fold}/{wc.phenotype}"),
        ),
    threads: config.get("threads", 4)
    shell:
        GELEX_FIT_CMD
