#!/bin/bash
if [[ $# == 3  ]]; then

	grep $3 $2$1.txt | sed 's/\|/ /'|awk '{print $1}' | sed 's/.$//' | sort
else
	echo "Algorithm graph-type and filename:linenumber"
	echo "for example, bfs kron bfs.cc:107"
	echo "Presumes that the data is in a file called:"
	echo "AlgorithmGraph-type.txt; e.g bfskron.txt"
fi
