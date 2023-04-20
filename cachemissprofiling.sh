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


	echo $extension
	echo $1
	echo $2

	if [[ $1 == bfs ]]; then
		echo "-----------------------------------------" >> bfs.txt
		sudo perf report --sort srcline --stdio | grep -E 'bfs.cc:53|bfs.cc:54|bfs.cc:55|bfs.cc:52|bfs.cc:57|bfs.cc:58|bfs.cc:77|bfs.cc:76|bfs.cc:79|bfs.cc:118|bfs.cc:96|bfs.cc:107' | sort -k 3  >> $2bfs.txt


	else
		sudo perf report --sort srcline,dso
	fi
else
    echo "First argument specifies graph algoritm..."
	echo "Second argument specifies graph type; 'kron' or 'uniform'."
	echo "For example, running bfs on a kronecker graph is done with:"
	echo "./cachemissprofiling.sh bfs kron"
fi


#grep bfs.cc:107 sorted_kronbfs.txt | sed 's/\|/ /'|awk '{print $1}' | sed 's/.$//'

