#!/bin/bash

# Runs the first rounds of tests

# PEBS; the option :pp -- works provided that the intel-microcode package is installed (debian)
#if [["$1" == *"help"*]];
#   then
#	   echo "Run BFS on a Kronecker graph with the argument 'kron' or a uniform graph with 'uni'"
#fi

if [[ $1 == -h  ]]; then
    echo "Provide the argument 'uni' to run on a uniform graph or 'kron' to run on a Kronecker graph."
	echo "The latter is run per default"
else
    echo ""
fi

if [[ $1 == uni ]]; then
	echo "Running BFS on uniform graph"
	sudo perf record -g -e L1-dcache-load-misses:pp --call-graph dwarf  ./bfs -f ./benchmark/krongraph.sg -n 40

	sudo perf report --sort srcline
else
	
	echo "Running BFS on Kronecker graph"
	sudo perf record -g -e L1-dcache-load-misses:pp --call-graph dwarf  ./bfs -f ./benchmark/krongraph.sg -n 40

	sudo perf report --sort srcline

fi

#sudo perf record -e L1-dcache-load-misses:pp -c 100 -g -- sleep 5 ./bfs -g 20 -n 1

#sudo perf record -e L1-dcache-load-misses ./bfs -g 20 -n 1

# Record with high-level instructions; no stack-trace.
# sudo perf record -e L1-dcache-load-misses:P ./bfs -f ./benchmark/krongraph.sg
# sudo perf record -e L1-dcache-load-misses:pp  ./bfs -f ./benchmark/krongraph.sg

#sudo perf record -e mem_load_uops_misc_retired.llc_miss:p ./bfs -f ./benchmark/krongraph.sg
# easy to read with perf annotate!


# Record with instructions with stack-trace.

## Using sleep
# sudo perf record -e L1-dcache-load-misses:pp -c 100 -g  ./bfs -f ./benchmark/krongraph.sg -n 10

#  sudo perf record -e L1-dcache-load-misses:pp -c 100 -g  --call-graph dwarf -- sleep 5 ./bfs -f ./benchmark/krongraph.sg

# With dwarf -- seems like the most suitable one... it's easy to ready with: sudo perf report --call-graph --stdio
# or just sudo perf report
# sudo perf record  -e L1-dcache-load-misses:pp -g  ./bfs -f ./benchmark/krongraph.sg
# sudo perf record -e L1-dcache-load-misses:pp --call-graph dwarf  ./bfs -f ./benchmark/krongraph.sg
 # sudo perf record -e L1-dcache-load-misses:pp --call-graph fp  ./bfs -f ./benchmark/krongraph.sg

# sudo perf record -g  -e L1-dcache-load-misses:pp --call-graph dwarf  ./bfs -f ./benchmark/krongraph.sg

# With dwarf + sleep -- seems to exclusively produce stack traces to the Linux kernel.
#  sudo perf record -g  -e L1-dcache-load-misses:pp -c 100 --call-graph dwarf sleep 5  ./bfs -f ./benchmark/krongraph.sg -n 10




# Present results
# sudo perf report --call-graph --stdio
# sudo perf annotate -i perf.data -l --full-paths --source   --stdio

# echo "Kronecker" >> bfs.txt
# echo "----------------------" >> bfs.txt
# sudo perf annotate --stdio >> bfs.txt


# sudo perf record -e L1-dcache-load-misses -c 100 -g -- sleep 5 ./bfs -u 20 -n 1
# sudo perf record -g  -e L1-dcache-load-misses:P --call-graph dwarf ./bfs -f ./benchmark/uniformgraph.sg


# echo "Uniform" >> bfs.txt
# echo "----------------------" >> bfs.txt
# sudo perf annotate --stdio >> bfs.txt



