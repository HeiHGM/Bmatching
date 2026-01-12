cc_library(
    name = "algorithm_impl_lib",
    srcs = [
        "algorithm_impl.cc",
        "greedy.cc",
        "ilp.cc",
        "ilp_exact.cc",
        "ils.cc",
        "presolved_ilp.cc",
        "reductions.cc",
        "scip.cc",
        "unfold.cc",
        "//:build-info.h",
        "//ds:hashing-config.h",
    ] + select({
        "//:karp_sipser": [
            "kss.cc",
        ],
        "//conditions:default": [
        ],
    }) + select({
        "//:bsuitor": [
            "bsuitor.cc",
        ],
        "//conditions:default": [
        ],
    }),
    hdrs = [
        "algorithm_impl.h",
        "greedy.h",
        "ilp.h",
        "ilp_exact.h",
        "ils.h",
        "presolved_ilp.h",
        "reductions.h",
        "scip.h",
        "unfold.h",
    ] + select({
        "//:karp_sipser": [
            "kss.h",
        ],
        "//conditions:default": [
        ],
    }) + select({
        "//:bsuitor": [
            "bsuitor.h",
        ],
        "//conditions:default": [
        ],
    }),
    copts = select({
        "//:bsuitor": [
            "-fopenmp",
            "-std=c++17",
        ],
        "//conditions:default": [
        ],
    }),
    linkopts = select({
        "//:bsuitor": [
            "-fopenmp",
        ],
        "//conditions:default": [
        ],
    }),
    visibility = ["//visibility:public"],
    deps = [
        "//app:app_io_cc_proto",
        "//bmatching/greedy",
        "//bmatching/ilp",
        "//bmatching/ils",
        "//bmatching/reductions_sorted",
        "//bmatching/scip",
        "//ds:bmatching_lib",
        "//io:graph_reader",
        "//io:hgr_reader",
        "//utils:systeminfo",
        "@com_google_absl//absl/container:flat_hash_set",
        "@com_google_absl//absl/status:statusor",
    ] + select({
        "//:karp_sipser": [
            "@ucar_matching//:matching_ksmd_lib",
            "@ucar_matching//:matching_kss_lib",
        ],
        "//conditions:default": [
        ],
    }) + select({
        "//:bsuitor": [
            "@pothen_b_matching//:bmatching_lib",
        ],
        "//conditions:default": [
        ],
    }),
    #set alwayslink to make sure register is called
    alwayslink = 1,
)
