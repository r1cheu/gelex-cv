RUN = config["run_id"]
K = config["kfold"]
FOLDS = list(range(K))


def results(path=""):
    return f"results/{RUN}/{path}"


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


wildcard_constraints:
    fold=r"\d+",
    split=r"train|test",
