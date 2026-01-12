cc_library(
    name = "ilp",
    hdrs = [
        "ilp_ball.h",
        "ilp_exact.h",
    ],
    defines = select({
        "//:gurobi": [
            "USE_GUROBI_ENABLED",
        ],
        "//conditions:default": [
        ],
    }),
    visibility = ["//visibility:public"],
    deps = [
        "//ds:bmatching_lib",
        "//ds:indexed_priority_queue",
        "//ds:modifiable_hypergraph_lib",
        "//utils:random_lib",
        "//utils:range_lib",
    ] + select({
        "//:gurobi": [
            "@grb//:gurobi_cxx",
        ],
        "//conditions:default": [
        ],
    }),
)
