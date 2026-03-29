rule gelex_predict:
    input:
        bed=results("fold_{fold}/test.bed"),
        bim=results("fold_{fold}/test.bim"),
        fam=results("fold_{fold}/test.fam"),
        snp_eff=results("fold_{fold}/model.snp.eff"),
        sbin=results("fold_{fold}/model.sbin"),
        param=results("fold_{fold}/model.param"),
    output:
        pred=temp(results("fold_{fold}/predictions.tsv")),
    params:
        bfile=lambda wc: results(f"fold_{wc.fold}/test"),
        gfile=lambda wc: results(f"fold_{wc.fold}/model"),
        extra=get_optional_predict_flags(),
    log:
        results("logs/gelex_predict_{fold}.log"),
    shell:
        "gelex predict"
        " --bfile {params.bfile}"
        " --gfile {params.gfile}"
        " --out {output.pred}"
        " {params.extra}"
        " &> {log}"
