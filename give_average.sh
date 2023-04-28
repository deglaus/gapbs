#!/bin/bash

if [[ $# == 3  ]]; then
#	lines="0 1"
	if [[ $1 == bfs ]]; then
		lines="52 53 54 55 57 58 76 77 79 96 107 118"
	fi
	if [[ $1 == sssp ]]; then
		lines="110 71 72 73 74 75 78 79"
	fi
	if [[ $1 == bc ]]; then
		lines="54 70 71 73 72 75 76 78 125 126 127 131"
	fi
	if [[ $1 == pr ]]; then
		lines="42 48 49 50 51 52 53"
	fi
	if [[ $1 == cc ]]; then
		lines="100 107 109 113 125 128 61 147 43 44 45 48 50 51 63 64"
	fi
	if [[ $1 == tc ]]; then
		lines="56 57 59 60 61 63 64 65 66"
	fi
		max=0
		for i in $lines; do

			newM=`./sort_by_line.sh $1 $2 $3 $1.cc:$i | wc -l`
			if [[ $newM -gt $max  ]]; then
				max=$newM
			fi			
		done

		echo "For $1 on a $2 graph,"
		echo "the number of samples for $3 misses is:"
		echo $max
		echo "--------------------------------------------------"

		for i in $lines; do
			length=`./sort_by_line.sh $1 $2 $3 $1.cc:$i | wc -l`
			if [[ $length -lt max ]]; then
				echo $i
				diff=$(expr $max - $length + 1)

				echo $diff
				for y in `seq 2 $diff`
				do
					echo "adding zeros to 00.00%     0.00%  $1.cc:$i"
					echo "00.00%     0.00%  $1.cc:$i" >> $2$1$3.txt
				done
			fi
		done

		for i in $lines; do
			echo $1.cc:$i
			answer=`./sort_by_line.sh $1 $2 $3 $1.cc:$i |  awk '{ sum+=$1 }END { print sum/NR }'`
			echo $answer
		done
	
	

else
	echo "./given_average alg graph event"
fi


