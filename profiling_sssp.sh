#!/bin/bash

if [[ $1 == -h  ]]; then
    echo "Provide the argument 'uni' to run on a uniform graph or 'kron' to run on a Kronecker graph."
	echo "The latter is run per default"
else
    echo ""
fi

if [[ $1 == uni ]]; then
	echo "Running SSSP on uniform graph"
	sudo perf record -g -e L1-dcache-load-misses:pp --call-graph dwarf  ./sssp -f ./benchmark/krongraph.wsg -n 40

	sudo perf report --sort srcline
else
	
	echo "Running SSSP on Kronecker graph"
	sudo perf record -g -e L1-dcache-load-misses:pp --call-graph dwarf  ./sssp -f ./benchmark/krongraph.wsg -n 40

	sudo perf report --sort srcline

fi
