#!/bin/bash
if [[ $# == 4  ]]; then

	grep $4 $2$1$3.txt | sed 's/\|/ /'|awk '{print $1}' | sed 's/.$//' | sort
else
	echo "Algorithm graph-type, event and filename:linenumber"
	echo "for example, bfs kron l1 bfs.cc:107"
	echo "Presumes that the data is in a file called:"
	echo "AlgorithmGraph-type.txt; e.g bfskron.txt"
fi
