cc_library(
    name = "modifiable_hypergraph_lib",
    srcs = ["modifiable_hypergraph.cc"],
    hdrs = [
        "bipartite_impl.h",
        "flat_bipartite_impl.h",
        "modifiable_hypergraph.h",
        "weight_sorted_bipartite_impl.h",
    ],
    visibility = ["//visibility:public"],
    deps = ["//utils:range_lib"],
)

cc_test(
    name = "modifiable_hypergraph_test",
    srcs = ["modifiable_hypergraph_test.cc"],
    deps = [
        ":bmatching_lib",
        ":modifiable_hypergraph_lib",
        "//bmatching/reductions_sorted",
        "//io:hgr_reader",
        "@com_google_googletest//:gtest_main",
    ],
)

config_setting(
    name = "hashing_config",
    values = {"define": "hashing=enabled"},
)

genrule(
    name = "hashing-config",
    srcs = [],
    outs = ["hashing-config.h"],
    cmd = select({
        ":hashing_config": "echo \"#define HASHING_ACTIVATED 1\">>$@",
        "//conditions:default": "echo \"#undef HASHING_ACTIVATED\">>$@",
    }),
    stamp = True,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "bmatching_lib",
    srcs = ["bmatching.cc"],
    hdrs = [
        "bmatching.h",
        "replay_buffer.h",
        ":hashing-config.h",
    ],
    visibility = ["//visibility:public"],
    deps = [
        ":modifiable_hypergraph_lib",
        "//utils:random_lib",
        "//utils:range_lib",
        "@easyloggingpp",
        "@wide_integer",
    ],
)

cc_library(
    name = "indexed_priority_queue",
    hdrs = ["indexed_priority_queue.h"],
    visibility = ["//visibility:public"],
    deps = [
    ],
)
