#!/usr/bin/env bash
# Regression test: compare Bazel and CMake CLI output on test instances.
# Run from the project root: bash build_regression/compare.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

BAZEL_APP="./bazel-bin/app/app"
CMAKE_CLI="./build/app/bmatching_cli"
TEST_DATA="$SCRIPT_DIR/testdata"

# Verify binaries exist
for bin in "$BAZEL_APP" "$CMAKE_CLI"; do
  if [ ! -x "$bin" ]; then
    echo "Error: $bin not found. Build both Bazel and CMake targets first."
    echo "  bazel build -c opt //app"
    echo "  ./compile.sh"
    exit 1
  fi
done

GRAPHS=(
  "$TEST_DATA/small.hgr"
  "$TEST_DATA/medium.hgr"
  "$TEST_DATA/hyper.hgr"
)

# Extract weight and size from textproto output (top-level, not nested)
extract_result() {
  local output="$1"
  local weight size is_exact
  weight=$(echo "$output" | grep -E '^weight:' | head -1 | awk '{print $2}')
  size=$(echo "$output" | grep -E '^size:' | head -1 | awk '{print $2}')
  is_exact=$(echo "$output" | grep -E '^is_exact:' | head -1 | awk '{print $2}')
  echo "weight=$weight size=$size exact=$is_exact"
}

PASS=0
FAIL=0

run_test() {
  local graph="$1"
  local name="$2"
  local capacity="$3"
  local textproto="$4"
  local cli_args="$5"
  local graph_base
  graph_base=$(basename "$graph")

  echo -n "  [$graph_base] $name (cap=$capacity) ... "

  # Bazel run
  local bazel_out
  bazel_out=$($BAZEL_APP --command_textproto "$textproto" 2>/dev/null) || {
    echo "BAZEL_FAIL"
    FAIL=$((FAIL + 1))
    return
  }
  local bazel_result
  bazel_result=$(extract_result "$bazel_out")

  # CMake run
  local cmake_out
  cmake_out=$($CMAKE_CLI $cli_args 2>/dev/null) || {
    echo "CMAKE_FAIL"
    FAIL=$((FAIL + 1))
    return
  }
  local cmake_result
  cmake_result=$(extract_result "$cmake_out")

  if [ "$bazel_result" = "$cmake_result" ]; then
    echo "PASS ($bazel_result)"
    PASS=$((PASS + 1))
  else
    echo "FAIL"
    echo "    Bazel:  $bazel_result"
    echo "    CMake:  $cmake_result"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Comparing Bazel vs CMake CLI results ==="
echo ""

for graph in "${GRAPHS[@]}"; do
  echo "Graph: $graph"

  # 1. greedy with various ordering methods
  for method in bweight bmindegree_dynamic bratio_dynamic bmaximize default_order; do
    for cap in 1 3; do
      run_test "$graph" "greedy($method)" "$cap" \
        "command:\"run\" hypergraph { file_path:\"$graph\" format:\"hgr\" } config { algorithm_configs { algorithm_name:\"greedy\" string_params{key:\"ordering_method\" value:\"$method\"} } capacity:$cap short_name:\"test\" }" \
        "--graph $graph --algorithms greedy --ordering_method $method --capacity $cap"
    done
  done

  # 2. reductions + unfold
  for cap in 1 3; do
    run_test "$graph" "reductions+unfold" "$cap" \
      "command:\"run\" hypergraph { file_path:\"$graph\" format:\"hgr\" } config { algorithm_configs { algorithm_name:\"reductions\" string_params{key:\"assume_sorted\" value:\"true\"} } algorithm_configs { algorithm_name:\"unfold\" string_params{key:\"assume_sorted\" value:\"true\"} } capacity:$cap short_name:\"test\" }" \
      "--graph $graph --algorithms reductions,unfold --capacity $cap"
  done

  # 3. reductions + greedy + unfold
  for cap in 1 3 5; do
    run_test "$graph" "reductions+greedy+unfold" "$cap" \
      "command:\"run\" hypergraph { file_path:\"$graph\" format:\"hgr\" } config { algorithm_configs { algorithm_name:\"reductions\" string_params{key:\"assume_sorted\" value:\"true\"} } algorithm_configs { algorithm_name:\"greedy\" string_params{key:\"ordering_method\" value:\"bmindegree_dynamic\"} } algorithm_configs { algorithm_name:\"unfold\" string_params{key:\"assume_sorted\" value:\"true\"} } capacity:$cap short_name:\"test\" }" \
      "--graph $graph --algorithms reductions,greedy,unfold --ordering_method bmindegree_dynamic --capacity $cap"
  done

  echo ""
done

echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] || exit 1
