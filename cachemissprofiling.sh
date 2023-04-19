#!/bin/bash

if [[ $# == 2  ]]; then


	if [[ $2 == uniform ]]; then
		echo "Execute on uniform graph..."	
	else
		
		echo "Execute on Kronecker graph..."
	fi


	echo "Running $1 on $2 graph."

	extension=sg

	if [[ $1 == sssp ]]; then
		extension=wsg
	fi

	sudo perf record -g -e L1-dcache-load-misses:pp --call-graph dwarf  ./$1 -f ./benchmark/$2graph.$extension -n 40



	sudo perf report --sort srcline

else
    echo "First argument specifies graph algoritm..."
	echo "Second argument specifies graph type; 'kron' or 'uniform'."
	echo "For example, running bfs on a kronecker graph is done with:"
	echo "./cachemissprofiling.sh bfs kron"
fi
