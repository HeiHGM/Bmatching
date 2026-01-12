cc_library(
    name = "external_graph_bmatching",
    srcs = [
        "//:build-info.h",
    ],
    hdrs = [
        "external_graph_bmatching.h",
    ],
    defines = select({
        "//:bsuitor": [
            "HEIHYPBMATCH_USE_BSUITOR",
        ],
        "//conditions:default": [
        ],
    }) + select({
        "//:karp_sipser": [
            "HEIHYPBMATCH_USE_KARP_SIPSER",
        ],
        "//conditions:default": [
        ],
    }),
    visibility = ["//visibility:public"],
    deps = [
        "//app:app_io_cc_proto",
        "@com_google_absl//absl/status:statusor",
    ] + select({
        "//:bsuitor": [
            ":bsuitor",
        ],
        "//conditions:default": [
        ],
    }) + select({
        "//:karp_sipser": [
            ":karp_sipser",
        ],
        "//conditions:default": [
        ],
    }),
    alwayslink = 1,
)

cc_library(
    name = "karp_sipser",
    srcs = [
        "karp_sipser.cc",
        "//:build-info.h",
    ],
    hdrs = ["karp_sipser.h"],
    deps = [
        "//app:app_io_cc_proto",
        "//utils:systeminfo",
        "@com_google_absl//absl/status:statusor",
        "@ucar_matching//:matching_ksmd_lib",
        "@ucar_matching//:matching_kss_lib",
    ],
)

cc_library(
    name = "bsuitor",
    srcs = [
        "bsuitor.cc",
        "//:build-info.h",
    ],
    hdrs = [
        "bsuitor.h",
    ],
    copts = [
        "-fopenmp",
        "-std=c++11",
    ],
    linkopts = [
        "-fopenmp",
    ],
    deps = [
        "//app:app_io_cc_proto",
        "//utils:systeminfo",
        "@pothen_b_matching//:bmatching_lib",
    ],
)
