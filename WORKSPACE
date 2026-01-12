load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")
load("//utils/workspace/gurobi:gurobi.bzl", "gurobi_home")

gurobi_home(name = "grb")

http_archive(
    name = "rules_proto",
    sha256 = "80d3a4ec17354cccc898bfe32118edd934f851b03029d63ef3fc7c8663a7415c",
    strip_prefix = "rules_proto-5.3.0-21.5",
    urls = [
        "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.5.tar.gz",
    ],
)

http_archive(
    name = "com_google_absl",
    strip_prefix = "abseil-cpp-b971ac5250ea8de900eae9f95e06548d14cd95fe",
    urls = ["https://github.com/abseil/abseil-cpp/archive/b971ac5250ea8de900eae9f95e06548d14cd95fe.zip"],
)

http_archive(
    name = "bazel_skylib",
    sha256 = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728",
    urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz"],
)

http_archive(
    name = "com_google_googletest",
    sha256 = "ab78fa3f912d44d38b785ec011a25f26512aaedc5291f51f3807c592b506d33a",
    strip_prefix = "googletest-58d77fa8070e8cec2dc1ed015d66b454c8d78850",
    urls = ["https://github.com/google/googletest/archive/58d77fa8070e8cec2dc1ed015d66b454c8d78850.zip"],
)

http_archive(
    name = "rules_foreign_cc",
    # TODO: Get the latest sha256 value from a bazel debug message or the latest
    #       release on the releases page: https://github.com/bazelbuild/rules_foreign_cc/releases
    #
    # sha256 = "...",
    strip_prefix = "rules_foreign_cc-8d540605805fb69e24c6bf5dc885b0403d74746a",
    url = "https://github.com/bazelbuild/rules_foreign_cc/archive/8d540605805fb69e24c6bf5dc885b0403d74746a.tar.gz",
)

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")

rules_foreign_cc_dependencies()

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

rules_proto_dependencies()

rules_proto_toolchains()

SQLITE_BAZEL_COMMIT = "14f9b46ded70f1009433804626b722466bb9e92e"

http_archive(
    name = "com_github_rockwotj_sqlite_bazel",
    strip_prefix = "sqlite-bazel-" + SQLITE_BAZEL_COMMIT,
    urls = ["https://github.com/rockwotj/sqlite-bazel/archive/%s.zip" % SQLITE_BAZEL_COMMIT],
)

git_repository(
    name = "com_google_protobuf",
    remote = "https://github.com/protocolbuffers/protobuf",
    tag = "v3.20.3",
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

_ALL_CONTENT = """\
cc_library(
     name = "bmatching_lib",
     srcs = ["bSuitor.cpp","bSuitorD.cpp","mtxReader.cpp"],
     hdrs= ["bMatching.h","mtxReader.h"],
     visibility = ["//visibility:public"],
     copts = ["-fopenmp","-O3","-std=c++11"],
)
 """

new_git_repository(
    name = "pothen_b_matching",
    build_file_content = _ALL_CONTENT,
    commit = "fee845cf7949a4947197cc93487634276bf69925",
    remote = "https://github.com/ECP-ExaGraph/bMatching",
)

_UCAR_ALL_CONTENT = """\
cc_library(
     name = "matching_kss_lib",
     srcs = ["kss/kss_utils.c"],
     hdrs = ["kss/kss_utils.h"],
     visibility = ["//visibility:public"],
)
cc_library(
     name = "matching_ksmd_lib",
     srcs = ["ksmd/ksmd_utils.c"],
     hdrs= ["ksmd/ksmd_utils.h"],
     visibility = ["//visibility:public"],
)
 """

new_git_repository(
    name = "ucar_matching",
    build_file_content = _UCAR_ALL_CONTENT,
    commit = "215f6887d7a3ec843ed70f3e9ea92a65e91a284a",
    remote = "https://gitlab.inria.fr/bora-ucar/karp-sipser-for-hypergraphs.git",
    shallow_since = "1615037533 +0100",
)

load("@rules_python//python:pip.bzl", "pip_parse")

# Create a central repo that knows about the dependencies needed for
# requirements.txt.
pip_parse(
    name = "python_deps",
    requirements_lock = "//tools/plot:requirements.txt",
)

load("@python_deps//:requirements.bzl", "install_deps")

install_deps()

http_archive(
    name = "ncurses",
    build_file = "//utils/workspace:BUILD.ncurses",
    sha256 = "57614210c8d4fd3464805eb4949f5d9d255d6248a8590ae446248c28f5facb7f",
    strip_prefix = "ncurses-6.4",
    urls = ["https://github.com/mirror/ncurses/archive/refs/tags/v6.4.zip"],
)

new_git_repository(
    name = "gperftools",
    build_file = "//utils/workspace:BUILD.gperftools",
    commit = "21277bb30b0c34b0d717f82484028d1a6d6d4322",
    remote = "https://github.com/henrixapp/gperftools.git",
)

new_git_repository(
    name = "scip",
    build_file = "//utils/workspace:BUILD.scip",
    commit = "e1ce3e22badba6c0135968d98f232e8b7a15ad8d",
    patch_args = ["-p1"],
    patches = ["//utils/workspace:scip.patch"],
    remote = "https://github.com/scipopt/scip",
)

new_git_repository(
    name = "wide_integer",
    build_file = "//utils/workspace:BUILD.wide_integer",
    commit = "d4ab8f42402d26bade2901fcc83c58a2bb9c5037",
    remote = "https://github.com/ckormanyos/wide-integer.git",
)

new_git_repository(
    name = "easyloggingpp",
    build_file = "//utils/workspace:BUILD.easyloggingpp",
    commit = "3bbb9a563858915b9624485356fcc7e0fdb4d68f",
    remote = "https://github.com/abumq/easyloggingpp.git",
)

new_local_repository(
    name = "libncurses",
    build_file = "//utils/workspace:BUILD.libncurses",
    path = ".spack-env/view/",
)

new_local_repository(
    name = "soplex",
    build_file = "//utils/workspace:BUILD.soplex",
    path = ".spack-env/view/",
)
