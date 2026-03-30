rule plink_subset:
    input:
        **bfile_inputs(config["bfile"]),
        keep=results("fold_{fold}/{split}_ids.txt"),
    output:
        bed=temp(results("fold_{fold}/{split}.bed")),
        bim=temp(results("fold_{fold}/{split}.bim")),
        fam=temp(results("fold_{fold}/{split}.fam")),
    params:
        bfile=config["bfile"],
        out=lambda wc: results(f"fold_{wc.fold}/{wc.split}"),
    log:
        results("logs/plink_subset_{fold}_{split}.log"),
    conda:
        "../envs/plink.yaml"
    shell:
        "plink --bfile {params.bfile} --keep {input.keep} "
        "--make-bed --out {params.out} &> {log}"
