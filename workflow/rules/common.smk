RUN = config["run_id"]
K = config["kfold"]
FOLDS = list(range(K))
PHENO_COLS = [str(c) for c in config.get("pheno_cols", [2])]
CV_MODE = K >= 2


def results(path=""):
    return f"results/{RUN}/{path}"


def bfile_inputs(prefix):
    return {ext: f"{prefix}.{ext}" for ext in ("bed", "bim", "fam")}


def get_optional_fit_flags():
    flags = []
    if config.get("dom"):
        flags.append("--dom")
    if config.get("asym"):
        flags.append("--asym")
    if config.get("estimate_pi"):
        flags.append("--estimate-pi")
    if config.get("mmap"):
        flags.append("--mmap")
    if config.get("qcovar"):
        flags.append(f"--qcovar {config['qcovar']}")
    if config.get("dcovar"):
        flags.append(f"--dcovar {config['dcovar']}")
    for key, flag in [("pi", "--pi"), ("scale", "--scale"), ("dpi", "--dpi"), ("dscale", "--dscale")]:
        if config.get(key):
            flags.append(f"{flag} {' '.join(str(x) for x in config[key])}")
    return " ".join(flags)


def get_optional_predict_flags():
    flags = []
    if config.get("qcovar"):
        flags.append(f"--qcovar {config['qcovar']}")
    if config.get("dcovar"):
        flags.append(f"--dcovar {config['dcovar']}")
    return " ".join(flags)


GELEX_FIT_CMD = (
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
)

GELEX_PREDICT_CMD = (
    "gelex predict"
    " --bfile {params.bfile}"
    " --gfile {params.gfile}"
    " --out {output.pred}"
    " {params.extra}"
)


def fit_params(bfile_fn, out_fn):
    return dict(
        bfile=bfile_fn,
        out=out_fn,
        method=config["method"],
        iters=config["iters"],
        burn_in=config["burn_in"],
        thin=config["thin"],
        seed=config["seed"],
        geno_method=config["geno_method"],
        chunk_size=config["chunk_size"],
        extra=get_optional_fit_flags(),
    )


wildcard_constraints:
    fold=r"\d+",
    split=r"train|test",
    pheno_col=r"\d+",
