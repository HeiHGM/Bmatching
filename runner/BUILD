cc_binary(
    name = "runner",
    srcs = ["runner.cc"],
    defines = select({
        "//:free_memory_check": ["HEIHYPBMATCH_MEMORY__REQ_CHECK"],
        "//conditions:default": [],
    }),
    linkopts = [],
    malloc = select({
        "//:gperftools_tcmalloc": "@gperftools",
        "//conditions:default": "@bazel_tools//tools/cpp:malloc",
    }),
    deps = [
        "//app:app_io_cc_proto",
        "@easyloggingpp",
        #  "@ncurses//:ncurses_lib",
        "@com_google_absl//absl/flags:flag",
        "@com_google_absl//absl/flags:parse",
        "@com_google_absl//absl/status:statusor",
        "//app/algorithms:algorithm_impl_lib",
        "//third_party:external_graph_bmatching",
    ] + select({
        "//:spack": ["@libncurses"],
        "//conditions:default": [],
    }),
)

cc_binary(
    name = "fork_runner",
    srcs = ["fork_runner.cc"],
    linkopts = [],
    malloc = select({
        "//:gperftools_tcmalloc": "@gperftools",
        "//conditions:default": "@bazel_tools//tools/cpp:malloc",
    }),
    deps = [
        "//app:app_io_cc_proto",
        "@easyloggingpp",
        "@com_google_absl//absl/flags:flag",
        "@com_google_absl//absl/flags:parse",
        "@com_google_absl//absl/status:statusor",
        "//app/algorithms:algorithm_impl_lib",
        "//third_party:external_graph_bmatching",
    ] + select({
        "//conditions:default": [],
    }),
)

cc_binary(
    name = "generate_experiment_config",
    srcs = ["generate_experiment_config.cc"],
    deps = [
        ":hypergraph_storage_system",
        "//app:app_io_cc_proto",
        "@com_google_absl//absl/flags:flag",
        "@com_google_absl//absl/flags:parse",
        "@com_google_absl//absl/status:statusor",
    ],
)

cc_library(
    name = "hypergraph_storage_system",
    srcs = ["hypergraph_storage_system.cc"],
    hdrs = ["hypergraph_storage_system.h"],
    visibility = ["//visibility:public"],
    deps = [
        "//app:app_io_cc_proto",
        "@com_google_absl//absl/strings",
    ],
)
