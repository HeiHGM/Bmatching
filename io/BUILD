cc_library(
    name = "hgr_reader",
    srcs = ["hgr_reader.cc"],
    hdrs = ["hgr_reader.h"],
    visibility = ["//visibility:public"],
    deps = [
        "//ds:modifiable_hypergraph_lib",
        "@com_google_absl//absl/status:statusor",
        "@com_google_absl//absl/strings",
        "@easyloggingpp",
    ],
)

cc_library(
    name = "graph_reader",
    hdrs = ["graph_reader.h"],
    visibility = ["//visibility:public"],
    deps = [
        "//ds:modifiable_hypergraph_lib",
        "@com_google_absl//absl/status:statusor",
        "@com_google_absl//absl/strings",
        "@easyloggingpp",
    ],
)

cc_binary(
    name = "mtx_to_unihypergraph",
    srcs = ["mtx_to_unihypergraph.cc"],
    deps = [
        ":hgr_writer",
        ":mtx_reader",
    ],
)

cc_binary(
    name = "hgr_validator",
    srcs = ["hgr_validator.cc"],
    deps = [
        ":hgr_reader",
        ":hgr_writer",
        "//runner:hypergraph_storage_system",
    ],
)

cc_binary(
    name = "write_mtx",
    srcs = ["write_mtx.cc"],
    deps = [
        ":hgr_reader",
        ":hgr_writer",
    ],
)

cc_binary(
    name = "hgr_without_weights_to_weighted_and_mtx",
    srcs = ["hgr_without_weights_to_weighted_and_mtx.cc"],
    deps = [
        ":hgr_reader",
        ":hgr_writer",
        "//app:app_io_cc_proto",
    ],
)

cc_library(
    name = "mtx_reader",
    hdrs = ["mtx_reader.h"],
    visibility = ["//visibility:public"],
    deps = [
        "//ds:modifiable_hypergraph_lib",
        "@com_google_absl//absl/strings",
    ],
)

cc_library(
    name = "hgr_writer",
    srcs = ["hgr_reader.cc"],
    hdrs = ["hgr_writer.h"],
    visibility = ["//visibility:public"],
    deps = [
        "//ds:modifiable_hypergraph_lib",
        "@com_google_absl//absl/strings",
    ],
)

cc_test(
    name = "hgr_reader_test",
    size = "small",
    srcs = ["hgr_reader_test.cc"],
    deps = [
        ":hgr_reader",
        "//ds:modifiable_hypergraph_lib",
        "@com_google_googletest//:gtest_main",
    ],
)

cc_binary(
    name = "hgr_import",
    srcs = ["import.cc"],
    deps = [
        ":hgr_reader",
        ":hgr_writer",
        "//app:app_io_cc_proto",
        "//runner:hypergraph_storage_system",
        "@com_google_absl//absl/flags:flag",
        "@com_google_absl//absl/flags:parse",
        "@com_google_absl//absl/status:statusor",
    ],
)
