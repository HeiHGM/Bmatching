load("@python_deps//:requirements.bzl", "requirement")

py_binary(
    name = "weight",
    srcs = [
        "dataloader.py",
        "optperfprofpy.py",
        "weight.py",
    ],
    deps = [
        "//app:app_io_py_proto",  # a py_library
        requirement("matplotlib"),
        requirement("numpy"),
        requirement("protobuf"),
        requirement("pandas"),
    ],
)

py_binary(
    name = "plot",
    srcs = [
        "dataloader.py",
        "optperfprofpy.py",
        "plot.py",
        "weight.py",
    ],
    deps = [
        "//app:app_io_py_proto",  # a py_library
        requirement("matplotlib"),
        requirement("numpy"),
        requirement("protobuf"),
        requirement("pandas"),
        requirement("scipy"),
        requirement("jinja2"),
        requirement("tikzplotlib"),
    ],
)

py_binary(
    name = "stats",
    srcs = [
        "dataloader.py",
        "optperfprofpy.py",
        "stats.py",
        "weight.py",
    ],
    deps = [
        "//app:app_io_py_proto",  # a py_library
        requirement("matplotlib"),
        requirement("numpy"),
        requirement("protobuf"),
        requirement("pandas"),
        requirement("jinja2"),
        requirement("scipy"),
        requirement("tikzplotlib"),
    ],
)

py_binary(
    name = "extract_exact",
    srcs = [
        "dataloader.py",
        "extract_exact.py",
    ],
    deps = [
        "//app:app_io_py_proto",  # a py_library
        requirement("matplotlib"),
        requirement("numpy"),
        requirement("protobuf"),
        requirement("pandas"),
        requirement("jinja2"),
        requirement("tikzplotlib"),
    ],
)
