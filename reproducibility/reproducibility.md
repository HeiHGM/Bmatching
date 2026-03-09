# Reproducing Experiments

This document describes how to reproduce the experiments from the paper:

> Ernestine Großmann, Felix Joos, Henrik Reinstädtler, and Christian Schulz.
> **Engineering Hypergraph *b*-Matching Algorithms.**
> *Journal of Graph Algorithms and Applications (JGAA)*, 30(1):1--24, 2026.

## 1. Get Experiment Data

Download hypergraph collections from [Zenodo](https://doi.org/10.5281/zenodo.18225669).

Expected layout:

```
graphs/
  walshaw/
    collection.textproto
    graph1.graph.hgr
    graph1.graph.mtx
storage.textproto
```

## 2. Build

```sh
./compile.sh
```

This builds the CLI, the runner, and all supporting tools.

## 3. Generate Experiment Configuration

```sh
mkdir my_experiment
./build/runner/generate_experiment_config \
  --data_path path/to/hypergraph-data \
  --experiment_name "my_experiment" \
  --experiment_path "my_experiment" \
  --concurrent_processes 16
```

## 4. Run the Experiment

```sh
./build/runner/runner --experiment_path my_experiment
```

The runner executes all configured algorithm pipelines across the hypergraph instances and writes results to the experiment directory.

## 5. Plot Results

The C++ plotting tool is the maintained version. Run it via Bazel:

```sh
bazel run -c opt tools/plot:plot_cc <path_to_experiment> <path_to_experiment>/visualisation.textproto
```
