genrule(
    name = "build-info",
    srcs = [],
    outs = ["build-info.h"],
    cmd = select({
        "//:gperftools_tcmalloc": "cat bazel-out/stable-status.txt | while read line; do echo \"#define $$line\" >> $@; done; echo \"#define MALLOC_IMPLEMENTATION \\\"tc-malloc\\\"\">>$@",
        "//conditions:default": "cat bazel-out/stable-status.txt | while read line; do echo \"#define $$line\" >> $@; done; echo \"#define MALLOC_IMPLEMENTATION \\\"default\\\"\">>$@",
    }),
    stamp = True,
    visibility = ["//visibility:public"],
)

config_setting(
    name = "gperftools_tcmalloc",
    values = {"define": "tcmalloc=gperftools"},
)

config_setting(
    name = "gurobi",
    values = {"define": "gurobi=enabled"},
)

config_setting(
    name = "scip",
    values = {"define": "scip=enabled"},
)

config_setting(
    name = "spack",
    values = {"define": "spack=enabled"},
)

config_setting(
    name = "karp_sipser",
    values = {"define": "karp_sipser=enabled"},
)

config_setting(
    name = "bsuitor",
    values = {"define": "bsuitor=enabled"},
)

config_setting(
    name = "free_memory_check",
    values = {"define": "free_memory_check=enabled"},
)
