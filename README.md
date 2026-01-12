# HeiHGM::BMatching

HeiHGM::BMatching is a program to solve bmatching in hypergraphs using reductions, integer linear programs and local search techniques.
It is the software for the paper:

**Engineering Hypergraph $b$-Matching Algorithms**

by Ernestine Großmann, Felix Joos, Henrik Reinstädtler and Christian Schulz


The latest software can be found at https://github.com/HeiHGM/Bmatching 

## Available Algorithms

### `greedy`

Greedly adding edges to a b matching. `ordering_method` can have the following values:

- `default_order` Iterates over all edges in order of their index once and adds all possible edges that are possible. Prior versions used the order in the bmatching data structure, that is dependening on prior operations due to the nature of the bmatching structure.
- `bmaximize` Maximizes the matching using the three compartement data structure. Greedly addes the first free edge in the data structure to the matching.
- `bweight` Sorts the edges by their weight and tries to add them in descending order.
- `bratio_static` Scales the edge weight by the capacities of the vertices of an edge, sorts them and add them in descending order.
- `bmult_static` Scales the edge by the minimal capacity of the vertices of an edge, sorts them and add them in descending order.
- `bratio_dynamic` Scales the edge weight by the residual capacity at each vertex of an edge. Recalculates after each addition to the matching.
- `bmindegree_dynamic` Scales the edge weight by the residual capacity and divide by the degree of a vertex in the edge. Recalculates the residual capacity after each addition.
- `bmindegree1_dynamic` Uses the product of 1/degree of vertex as ordering method.

### `ilp_exact`

Exactly solves a bmatching using gurobi with a `timeout` of seconds.  You need to build with `--define gurobi=enabled` to use this.

`timeout` needs to be specified in `double_params`.

### `ils`

Using an a priori solution the iterated local search searches for edge pairs that can be swapped into the solution. Afterwards it perturbs the solution to escape local optima and starts searching again.
You have to specify a `timeout`in `double_params`.

### `local_improvement`

Locally improve solution quality by ILP via Gurobi. You need to specify `iters` and `distance` (`int64_params`) and a `timeout` (`double_params`). Distance is the number of edges that will be taken from the graph to be improved. `iters` controls how many iterations of local improvement will be done. `timeout` specifies a timeout on the iterations.

### `presolved_ilp`

Solves the remainder of a graph (e.g. after applying reductions) exactly using ILP via Gurobi. You have to specify a `timeout` (`double_params`). You need to build with `--define gurobi=enabled` to use this.

### `reductions` & `unfold`

Reduces the graph with our reductions for b matching problem. At the end you should call `unfold` to obtain the unfolded solution. 

Optional setting (disable_hint: "true") to not set the hint to following steps that the solution is exact.

Optional setting (assume_sorted: "true") to use implementations that assume the edges/nodes to be sorted, so that certain operations get a better complexity. 

### `scip`

Solves the remainder of a graph (e.g. after applying reductions) exactly using ILP via SCIP. You have to specify a `timeout` (`double_params`).

## External Algorithms

In order to compare results more accurately and have a unified workflow for storing results, we are automatically  building and linking `bSuitor` by Khan et al. and `kss`/ `ksmd` by Dufosse et al. into our `runner` target. The integration can be found in app/algorithms/<name of the competitor>

You can enable building with bazel them with `bsuitor=enabled` and `karp_sipser=enabled`.
### bSuitor

**`name`**: `bsuitor`

**Authors:** Khan et al.


### Karp-Sipser scaling

Can only run on capacity 1.

**`name`** `kss`or `ksmd`

**Authors:** Dufosse et al.


**External options:** `kss`: KSS iterations in `scaling_iterations` int64_params.


## Adding an algorithm



1. Implement your (templated) algorithms in a `bmatching` subfolder.
2. Write an `AlgorithmImpl` in `app/algorithms`. You must implement two functions. One to execute and one to validate a config. You can read `double_params`,`int64_params` and `string_params`. Please refer to the [app/app_io.proto](app/app_io.proto#L39).
3. Give your implementation a unique AlgorithmName.
4. Register your implementation via the `REGISTER_IMPL` macro.
5. You can now write `run_configs` using your algorithm.



## Compiling

HeiHGM::BMatching uses [bazel](https://bazel.build) as build system. After installing bazel, feel free to follow the tutorial below. Please use clang as your compiler suite (as MPI flags are configured for this compiler suite).

We extensivly use (text)proto as format for storing configs and results. The proto definition can be found in `app/app_io.proto`.

### Gurobi macOS support

To use on a mac please uncomment `--cxxopt=-stdlib=libc++` in [`.bazelrc`](.bazelrc) if you manually compiled Gurobi with a different stdlib.

### Configurable settings

You can enable gurobi with `gurobi=enabled`.

You can enable edge hashing used in Weighted Domination reduction with defining `hashing=enabled` while building `//app` or `//runner` targets, e.g.:

```sh
bazel build -c opt --define hashing=enabled //runner
```
Furthermore, you can use a different malloc implementation and use it for profiling:
```sh
bazel build -c opt --define tcmalloc=gperftools //runner
```
Profiling then can be enabled by defining the `CPUPROFILE` env variable.

Note on mac you have to comment `--cxxopt=-frecord-gcc-switches` out in .bazelrc
### openmp on mac

Please install `open-mpi` and `llvm` via brew. MPI is used by external software to be used for comparison.
Prepend commands by `BAZEL_USE_CPP_ONLY_TOOLCHAIN=1 CC=/opt/homebrew/opt/llvm/bin/clang` in order to use the different (non-apple) llvm.

## Running one-off computations (`app`)

Build the `//app` target and supply a simple config via the `command_textproto` option:

```sh
bazel build -c opt //app
./bazel-bin/app/app --command_textproto 'command:"run" hypergraph {    file_path: "<path to hypergraph file>"    format: "hgr" } config {   algorithm_configs{algorithm_name:"reductions" string_params{key:"disable_hint" value:"false"} string_params{key:"assume_sorted" value:"true"}}    algorithm_configs{algorithm_name:"unfold" string_params{key:"assume_sorted" value:"true"}}    capacity: 1   short_name: "only_reductions" }'
```
## Running an experiment

### Getting experiment data

To get a collection of hypergraphs visit [Zenodo](https://doi.org/10.5281/zenodo.18225669). The storage of hypergraphs is organized as follows:

```
├── graphs
│   └── walshaw
│       ├── collection.textproto
|       ├── ...
│       ├── graph1.graph
│       ├── graph1.graph.hgr
│       ├── graph1.graph.weighted.hgr
│       └── graph1.graph.weighted.hgr.mtx
├── README.md
└── storage.textproto
```

- `storage.textproto`: file containing info about the repository, can be empty.
- `collection.textproto`: per directory/collection contains the list of hypergraphs and information about the files. Definition in [app_io.proto](app/app_io.proto#L117).

Example:

```
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
hypergraphs {
  name: "wing_nodal.graph"
  edge_weight_type: "random(100)"
  collection: "dimacs10(graph)"
  file_path: "wing_nodal.graph.weighted.hgr.mtx"
  node_count: 10937
  edge_count: 75488
  format: "mtx"
  node_weight_type: "random(degree)"
  sort: "walshaw"
}
collection_name: "dimacs10(graph)"
version: "1.0"
```
- `*.hgr` graphs in hMetis format.
- `*.mtx` graphs in mtx format (symmetric) for third_party solver, mainly used for graphs.

### Setting up an experiment

To generate the an experiment use the `//runner:generate_experiment_config` target to generate an example.

Generate an experiment with default order via `bmindegree_dynamic` and default capacity `5` with `16` concurrent cores.
```sh
bazel build -c opt //runner:generate_experiment_config # compile the target
mkdir <experiment_directory> # important generate the experiment_directory
./bazel-bin/runner/generate_experiment_config --data_path path/to/hypergraph-data --experiment_name "<name of experiment>" --experiment_path="<experiment_directory>" --hypergraph_filter='format:"hgr" edge_weight_types:"random(100)" sort:"walshaw"' --run_configs='run_configs { algorithm_configs { algorithm_name: "greedy" string_params {key: "ordering_method" value: "bmindegree_dynamic"}} capacity: 5 short_name: "bmindegree_dynamic5"}' --concurrent_processes 16
```


This generates an `experiment.textproto` in the folder `<experiment_directory>`. You can modify this file with any text editor and edit the `run_configs`.

### Running an experiment

Build the runner in opt settings:

```sh
bazel build -c opt //runner
```

and run 

```sh
./bazel-bin/runner/runner --experiment_path <experiment_directory>
```

This will execute the tasks in `concurrent_processes` parallel processes as configured in `experiment.textproto` generated in the previous step.

### Analysing the results

The results are stored in `results-*-<concurrent_processes>.binary_proto` in binaryproto to save some storage.
Plotting is done via the `tools/plot` tool using the visualisation proto. The following proto generates 4 plots (each for a different capacity) for 
the experiment in subpath `"mm-eweight-random100_greedy"` with type `performance_profile`.

```
visualisations {
    capacity: 1
    capacity: -1
    capacity: 3
    capacity: 5
    experiment_paths: "mm-eweight-random100_greedy"
    type:"performance_profile"
    title: "Performance Profile on $num planted hypergraphs\n (e-weight random(100),capacity $capacity)"
    folder_name:"mm-eweight-random100_greedy"
    file_prefix: "performance_plot_"
}
```

To show this example use the `tools/plot/plot.py` by running:

```sh
bazel run tools/plot -- <path to experiment git> <path to experiment git>/<subfolder of experiment>/visualisation.textproto
```
The plots are stored in `<path to experiment git>/vis/<folder_name>`.

## Logging

By default `HeiHGM::BMatching` does not log, you can enable it by adding `--define logging=enabled`.

If build with logging enabled, you can define a verbosity level by supplying to HeiHGM::BMatching `--undefok=v --v=<level>`

Verbosity levels:

| Level | Functions |
| ----- | ----- |
| 8     | addToMatching, removeFromMatching |

## Usage with `spack`


`spack` is a tool to manage software on compute clusters.
We use it to manage system dependencies. Otherwise, you should take care of linking yourself.
```sh
#install spack 
git clone --depth=100 --branch=releases/v0.20 https://github.com/spack/spack.git
cd spack
. share/spack/setup-env.sh
# change to bmatching
cd bmatching
spack env activate .
spack install
spack load
# build as used to be with spack=enabled
```
