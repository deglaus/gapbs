#!/bin/bash

if [[ $1 == -h  ]]; then
    echo "Provide the argument 'uni' to run on a uniform graph or 'kron' to run on a Kronecker graph."
	echo "The latter is run per default"
else
    echo ""
fi

if [[ $1 == uni ]]; then
	echo "Running BC on uniform graph"
	sudo perf record -g -e L1-dcache-load-misses:pp --call-graph dwarf  ./bc -f ./benchmark/krongraph.sg -n 40

	sudo perf report --sort srcline
else
	
	echo "Running BC on Kronecker graph"
	sudo perf record -g -e L1-dcache-load-misses:pp --call-graph dwarf  ./bc -f ./benchmark/krongraph.sg -n 40

	sudo perf report --sort srcline

fi
