rule gelex_post:
    input:
        snp_eff=results("{phenotype}/fold_{fold}/{phenotype}.snp.eff"),
        sbin=results("{phenotype}/fold_{fold}/{phenotype}.sbin"),
        param=results("{phenotype}/fold_{fold}/{phenotype}.param"),
    output:
        log=results("{phenotype}/fold_{fold}/{phenotype}_post.log"),
    params:
        gfile_in=lambda wc: results(f"{wc.phenotype}/fold_{wc.fold}/{wc.phenotype}"),
        gfile_out=lambda wc: results(f"{wc.phenotype}/fold_{wc.fold}/{wc.phenotype}_post"),
    shell:
        GELEX_POST_CMD
