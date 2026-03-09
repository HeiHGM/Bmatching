# HeiHGM::BMatching

A solver for b-matching problems in hypergraphs using reductions, integer linear programs, and local search techniques.

This is the software for the paper:

> **Engineering Hypergraph b-Matching Algorithms**
> by Ernestine Großmann, Felix Joos, Henrik Reinstädtler and Christian Schulz

Source code: https://github.com/HeiHGM/Bmatching

---

## Quick Start

```sh
# Clone & build
git clone https://github.com/HeiHGM/Bmatching.git
cd Bmatching
./compile.sh

# Greedy matching
./build/app/bmatching_cli --graph path/to/graph.hgr --algorithms greedy --capacity 1

# Reductions + greedy + unfold
./build/app/bmatching_cli --graph path/to/graph.hgr --algorithms reductions,greedy,unfold --capacity 5

# Compact output (weight, size, time only)
./build/app/bmatching_cli --graph path/to/graph.hgr --algorithms reductions,greedy,unfold --quiet
```

---

## Building

**Prerequisites:** CMake >= 3.20, a C++17 compiler, and ncurses dev headers.

```sh
./compile.sh            # Release build (default)
./compile.sh Debug      # Debug build
```

Or manually:

```sh
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
```

All external dependencies (Abseil, Protobuf, GoogleTest, Easylogging++, wide-integer) are fetched automatically via CMake's FetchContent.

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `BMATCHING_USE_GUROBI` | OFF | Enable Gurobi ILP solver (requires local install, set `GUROBI_HOME`) |
| `BMATCHING_USE_SCIP` | OFF | Enable SCIP solver |
| `BMATCHING_USE_BSUITOR` | OFF | Enable bSuitor algorithm (fetched via git) |
| `BMATCHING_USE_KARP_SIPSER` | OFF | Enable Karp-Sipser algorithm (fetched via git) |
| `BMATCHING_USE_HASHING` | OFF | Enable edge hashing for Weighted Domination reduction |
| `BMATCHING_USE_TCMALLOC` | OFF | Use tcmalloc from gperftools |
| `BMATCHING_ENABLE_LOGGING` | ON | Enable easylogging++ log output |
| `BMATCHING_FREE_MEMORY_CHECK` | OFF | Enable free memory checking in runner |
| `BUILD_TESTING` | ON | Build unit tests |

Example with Gurobi and bSuitor enabled:

```sh
cmake -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DBMATCHING_USE_GUROBI=ON \
  -DBMATCHING_USE_BSUITOR=ON
cmake --build build -j$(nproc)
```

### Built Binary

After building, the CLI is available at:

```
build/app/bmatching_cli
```

---

## Algorithms

Algorithms are selected via `--algorithms` in the CLI (comma-separated pipeline). See [app/app_io.proto](app/app_io.proto) for the full proto definition.

### `greedy`

Greedily adds edges to a b-matching. Set the `ordering_method` string parameter:

| Ordering Method | Description |
|-----------------|-------------|
| `default_order` | Iterates over edges in index order, adds all possible edges |
| `bmaximize` | Uses a three-compartment data structure, greedily adds the first free edge |
| `bweight` | Sorts edges by weight, adds in descending order |
| `bratio_static` | Scales edge weight by vertex capacities, sorts descending |
| `bmult_static` | Scales edge by minimal vertex capacity, sorts descending |
| `bratio_dynamic` | Scales by residual capacity, recalculates after each addition |
| `bmindegree_dynamic` | Scales by residual capacity / vertex degree, recalculates dynamically |
| `bmindegree1_dynamic` | Uses product of 1/degree as ordering |

### `ilp_exact`

Exactly solves a b-matching using Gurobi. Requires `BMATCHING_USE_GUROBI=ON`.

- `timeout` (double_params): solver time limit in seconds

### `ils`

Iterated local search: searches for edge-pair swaps to improve an a priori solution, then perturbs to escape local optima. Requires an a priori solution (run greedy first).

- `max_tries` (int64_params / `--max_tries`): maximum number of search iterations
- `inplace` (string_params / `--inplace`): modify matching in-place

### `local_improvement`

Locally improves solution quality by ILP via Gurobi.

- `iters` (int64_params): number of improvement iterations
- `distance` (int64_params): number of edges taken from the graph per iteration
- `timeout` (double_params): time limit in seconds

### `presolved_ilp`

Solves the reduced graph exactly using ILP via Gurobi. Requires Gurobi to be enabled.

- `timeout` (double_params): time limit in seconds

### `reductions` & `unfold`

Reduces the graph size using b-matching reductions. Call `unfold` afterwards to recover the full solution.

Optional string parameters:
- `disable_hint: "true"` — do not signal to subsequent steps that the solution is exact
- `assume_sorted: "true"` — use implementations that assume sorted edges/nodes for better complexity

### `scip`

Solves the reduced graph exactly using ILP via SCIP.

- `timeout` (double_params): time limit in seconds

### External Algorithms

For comparison, the `runner` can link external solvers. These are fetched automatically when enabled.

| Algorithm | Enable Flag | Authors |
|-----------|-------------|---------|
| **bSuitor** | `BMATCHING_USE_BSUITOR=ON` | Khan et al. |
| **kss** / **ksmd** | `BMATCHING_USE_KARP_SIPSER=ON` | Dufosse et al. |

Note: `kss`/`ksmd` only supports capacity 1. For `kss`, set `scaling_iterations` in `int64_params`.

---

## Command-Line Interface (`bmatching_cli`)

`bmatching_cli` provides a flag-based interface for running all algorithms without writing textproto configs.

### Basic Usage

```sh
bmatching_cli --graph <file> --algorithms <algo1,algo2,...> [options]
```

### Required Flags

| Flag | Description |
|------|-------------|
| `--graph <path>` | Path to the hypergraph file |
| `--algorithms <list>` | Comma-separated algorithm pipeline (e.g. `reductions,greedy,unfold`) |

### Common Flags

| Flag | Default | Description |
|------|---------|-------------|
| `--capacity <int>` | 1 | Node capacity (`-1` = use node weights from file) |
| `--format <str>` | `hgr` | Input format: `hgr` or `graph` |
| `--ordering_method <str>` | `bmindegree_dynamic` | Greedy ordering method (see [Algorithms](#algorithms)) |
| `--timeout <float>` | 60.0 | Solver timeout in seconds (ilp_exact, presolved_ilp, scip, local_improvement) |
| `--max_tries <int>` | 1000 | Max iterations for ILS / local search |
| `--iters <int>` | 10 | Local improvement iterations |
| `--distance <int>` | 5 | Edges per local improvement neighborhood |
| `--backend <str>` | `gurobi` | Solver backend for local_improvement: `gurobi` or `scip` |
| `--disable_hint` | false | Don't mark reductions solution as exact |
| `--max_runs <int>` | 10 | Maximum reduction rounds |
| `--reps <int>` | 1 | Number of reduction repetitions |
| `--inplace` | false | Run ILS in-place |

### Output Flags

| Flag | Default | Description |
|------|---------|-------------|
| `--quiet` | false | Only print weight, size, exactness, and time |
| `--output <path>` | stdout | Write result to file |
| `--output_format <str>` | `text` | Output format: `text` (textproto), `json`, or `binary` |

### Examples

```sh
# Greedy with specific ordering
bmatching_cli --graph input.hgr --algorithms greedy --ordering_method bweight --capacity 3

# Full pipeline: reductions + greedy + unfold
bmatching_cli --graph input.hgr --algorithms reductions,greedy,unfold --capacity 5

# Reductions + ILS refinement + unfold
bmatching_cli --graph input.hgr --algorithms reductions,greedy,ils,unfold \
  --max_tries 5000 --capacity 1

# Exact solve with reductions (requires Gurobi)
bmatching_cli --graph input.hgr --algorithms reductions,presolved_ilp,unfold \
  --timeout 300 --capacity 1

# SCIP exact solve
bmatching_cli --graph input.hgr --algorithms reductions,scip,unfold \
  --timeout 120 --capacity 3

# Local improvement with SCIP backend
bmatching_cli --graph input.hgr --algorithms reductions,greedy,local_improvement,unfold \
  --backend scip --iters 20 --distance 10 --timeout 60 --capacity 1

# Compact output
bmatching_cli --graph input.hgr --algorithms reductions,greedy,unfold --quiet
# weight: 42
# size: 15
# exact: false
# time_ms: 1.234

# JSON output to file
bmatching_cli --graph input.hgr --algorithms greedy --output_format json --output result.json
```

### Legacy Textproto Interface (`app`)

The original `app` binary is still available for textproto-based configs:

```sh
./build/app/app --command_textproto '
  command: "run"
  hypergraph { file_path: "path/to/graph.hgr" format: "hgr" }
  config {
    algorithm_configs {
      algorithm_name: "reductions"
      string_params { key: "assume_sorted" value: "true" }
    }
    algorithm_configs { algorithm_name: "unfold" }
    capacity: 1
    short_name: "only_reductions"
  }'
```

---

## Running Experiments

### 1. Get Experiment Data

Download hypergraph collections from [Zenodo](https://doi.org/10.5281/zenodo.18225669). The expected directory layout:

```
graphs/
  walshaw/
    collection.textproto    # list of hypergraphs in this collection
    graph1.graph.hgr        # hMetis format
    graph1.graph.mtx        # Matrix Market format (for third-party solvers)
storage.textproto           # repository info (can be empty)
```

Each `collection.textproto` lists hypergraphs with metadata. Example entry:

```protobuf
hypergraphs {
  name: "wing_nodal.graph"
  edge_weight_type: "random(100)"
  collection: "dimacs10(graph)"
  file_path: "wing_nodal.graph.weighted.hgr"
  node_count: 10937
  edge_count: 75488
  format: "hgr"
  node_weight_type: "random(degree)"
  sort: "walshaw"
}
collection_name: "dimacs10(graph)"
version: "1.0"
```

### 2. Generate Experiment Config

```sh
mkdir my_experiment

./build/runner/generate_experiment_config \
  --data_path path/to/hypergraph-data \
  --experiment_name "my_experiment" \
  --experiment_path "my_experiment" \
  --hypergraph_filter 'format:"hgr" edge_weight_types:"random(100)" sort:"walshaw"' \
  --run_configs '
    run_configs {
      algorithm_configs {
        algorithm_name: "greedy"
        string_params { key: "ordering_method" value: "bmindegree_dynamic" }
      }
      capacity: 5
      short_name: "bmindegree_dynamic5"
    }' \
  --concurrent_processes 16
```

This creates `experiment.textproto` in the experiment directory. Edit it with any text editor to adjust `run_configs`.

### 3. Run the Experiment

```sh
./build/runner/runner --experiment_path my_experiment
```

Tasks execute in parallel using the number of `concurrent_processes` configured in `experiment.textproto`.

### 4. Analyze Results

Results are stored as `results-*-<concurrent_processes>.binary_proto`. To plot:

Create a `visualisation.textproto`:

```protobuf
visualisations {
  capacity: 1
  capacity: -1
  capacity: 3
  capacity: 5
  experiment_paths: "mm-eweight-random100_greedy"
  type: "performance_profile"
  title: "Performance Profile on $num planted hypergraphs\n (e-weight random(100), capacity $capacity)"
  folder_name: "mm-eweight-random100_greedy"
  file_prefix: "performance_plot_"
}
```

Then run the plotting tool:

```sh
python3 tools/plot/plot.py <path_to_experiment> <path_to_experiment>/visualisation.textproto
```

Plots are saved to `<path_to_experiment>/vis/<folder_name>/`.

---

## Logging

Logging is enabled by default (`BMATCHING_ENABLE_LOGGING=ON`).

To disable: set `BMATCHING_ENABLE_LOGGING=OFF` at cmake configure time.

When enabled, control verbosity at runtime:

```sh
./build/app/app --undefok=v --v=<level> ...
```

| Level | Functions |
|-------|-----------|
| 8 | `addToMatching`, `removeFromMatching` |

---

## Adding a New Algorithm

1. Implement your (templated) algorithm in a `bmatching/` subfolder.
2. Write an `AlgorithmImpl` in `app/algorithms/` — implement `Execute` and `ValidateConfig`. Read parameters from `double_params`, `int64_params`, and `string_params` (see [app/app_io.proto](app/app_io.proto)).
3. Give your implementation a unique `AlgorithmName`.
4. Register it via the `REGISTER_IMPL` macro.
5. Use your algorithm in `run_configs` by name.

---

## Usage with Spack

[Spack](https://spack.io) manages system dependencies on compute clusters:

```sh
# Install spack
git clone --depth=100 --branch=releases/v0.20 https://github.com/spack/spack.git
cd spack && . share/spack/setup-env.sh

# Activate environment in BMatching directory
cd /path/to/Bmatching
spack env activate .
spack install
spack load
```

Then build as usual.
