class Bmatching < Formula
  desc "High-performance solver for b-matching problems in hypergraphs"
  homepage "https://github.com/HeiHGM/Bmatching"
  url "https://github.com/HeiHGM/Bmatching.git",
      tag:      "v1.0.0",
      revision: "7f0ef58e8c482c61b9feaeb60d70c698b14c1757"
  license "MIT"
  head "https://github.com/HeiHGM/Bmatching.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "ncurses"

  def install
    gcc = Formula["gcc"]
    gcc_version = gcc.version.major

    # Filter out Homebrew's FetchContent trap — we bundle all deps via FetchContent.
    cmake_args = std_cmake_args.reject { |a| a.start_with?("-DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=") }

    system "cmake", "-B", "build",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DBUILD_TESTING=OFF",
                    "-DBMATCHING_ENABLE_LOGGING=OFF",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-#{gcc_version}",
                    "-DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-#{gcc_version}",
                    *cmake_args
    system "cmake", "--build", "build", "-j#{ENV.make_jobs}", "--target", "bmatching_cli"

    bin.install "build/app/bmatching_cli"
    pkgshare.install Dir["examples/*"]
  end

  test do
    (testpath/"test.hgr").write <<~EOS
      4 4
      1 2
      2 3
      3 4
      1 4
    EOS
    output = shell_output("#{bin}/bmatching --graph #{testpath}/test.hgr --algorithms greedy --capacity 1 --quiet")
    assert_match "weight:", output
  end
end
