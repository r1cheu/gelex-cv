rule gelex_fit:
    input:
        bed=results("fold_{fold}/train.bed"),
        bim=results("fold_{fold}/train.bim"),
        fam=results("fold_{fold}/train.fam"),
        pheno=config["pheno"],
    output:
        snp_eff=results("fold_{fold}/model.snp.eff"),
        sbin=results("fold_{fold}/model.sbin"),
        param=results("fold_{fold}/model.param"),
    params:
        bfile=lambda wc: results(f"fold_{wc.fold}/train"),
        out=lambda wc: results(f"fold_{wc.fold}/model"),
        method=config["method"],
        pheno_col=config.get("pheno_col", 2),
        iters=config.get("iters", 5000),
        burn_in=config.get("burn_in", 3000),
        thin=config.get("thin", 1),
        seed=config.get("seed", 42),
        geno_method=config.get("geno_method", "OSH"),
        chunk_size=config.get("chunk_size", 10000),
        extra=get_optional_fit_flags(),
    threads: config.get("threads", 4)
    log:
        results("logs/gelex_fit_{fold}.log"),
    shell:
        "gelex fit"
        " --pheno {input.pheno}"
        " --bfile {params.bfile}"
        " --method {params.method}"
        " --pheno-col {params.pheno_col}"
        " --iters {params.iters}"
        " --burn-in {params.burn_in}"
        " --thin {params.thin}"
        " --seed {params.seed}"
        " --geno-method {params.geno_method}"
        " --chunk-size {params.chunk_size}"
        " --threads {threads}"
        " --out {params.out}"
        " {params.extra}"
        " &> {log}"
