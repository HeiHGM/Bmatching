cc_library(
    name = "scip",
    hdrs = [
        "solver.h",
    ],
    defines = select({
        "//:scip": ["HEIPHYPBMATCH_USE_SCIP"],
        "//conditions:default": [
        ],
    }),
    visibility = ["//visibility:public"],
    deps = [
        "//ds:bmatching_lib",
        "//ds:modifiable_hypergraph_lib",
        "//utils:random_lib",
        "//utils:range_lib",
    ] + select({
        "//:scip": [
            "@scip",
        ],
        "//conditions:default": [
        ],
    }) + select({
        "//:spack": ["@soplex"],
        "//conditions:default": [],
    }),
)
