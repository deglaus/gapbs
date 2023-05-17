#!/bin/bash

if [[ $# == 3  ]]; then
	

	if [[ $3 == llc-count || $3 == l1-count  ]]; then
		echo "$1 on $2 graph"
		echo average miss-rate:
		echo "---------------------------------------------"
			
		if [[ $1 == pr ]]; then
			insts=("f3 0f 58 04 96" "49 39 c3" "48 63 10")

		elif [[ $1 == bfs ]]; then
			insts=("48 8b 04 f8" "48 63 30" "49 8b 34 f7")
		
		elif [[ $1 == bc ]]; then
			insts=("48 63 02" "49 8b 0a" "f3 41 0f 10 14 80" "f2 42 0f 10 04 09" "f2 0f 5e 04 c1" "f3 0f 58 d3" "f3 0f 5a d2" "f2 0f 59 c2" "f2 0f 58 c8" "f2 0f 5a c9")
		elif [[ $1 == cc ]]; then
			insts=("49 8b 54 24 08" "8b 30" "44 89 ef" "e8 ee fe ff ff" "4c 63 c7" "48 8b 3a" "48 63 f6" "49 89 d1" "42 8b 0c 87" "8b 04 b7" "39 c1" "74 2b" "39 c8" "89 ce" "0f 4d f0" "29 f0" "4c 63 c6" "8d 14 08" "4a 8d 0c 87" "48 63 01" "39 c2")
			
		fi

		
		for inst in "${insts[@]}"; do
			echo $inst
			echo cat $1$2_count_$3.txt | grep "$inst" | grep 'RATE:'
			samples=` cat $1$2_count_$3.txt | grep -c "$inst"`
			sum=` cat $1$2_count_$3.txt | grep "$inst" | grep -o 'RATE: [0-9.]*' | awk '{sum+=$2} END {if(NR>0) print sum/NR}'`
			echo $sum
			echo "Samples: $samples"
			
		done

				
		exit 1
		
			fi
	if [[ $3 == l1num  ]]; then
		cat $1$2_counting_$3.txt | awk '{ sum+=$1 }END { print sum/NR }'
		exit 1
	fi
	if [[ $3 == llcnum  ]]; then
		echo "total LLC misses:"
		cat $1$2_counting_$3.txt | awk '{ sum+=$1 }END { print sum/NR }'
		# IPC calculation
		ipc_sum=0
		ipc_count=0
		
		# MPKI calculation
		mpki_sum=0
		mpki_count=0
		
		# Read input from file
		filename="$1$2_ips_mpki_$3.txt"
		
		while IFS=': ' read -r label value; do
			if [[ $label == "ipc" ]]; then
				ipc_sum=$(bc <<< "$ipc_sum + $value")
				((ipc_count++))
			elif [[ $label == "mpki" ]]; then
				mpki_sum=$(bc <<< "$mpki_sum + $value")
				((mpki_count++))
			fi
		done < "$filename"
		
		# Calculate average values
		ipc_avg=$(echo "scale=10; $ipc_sum / $ipc_count" | bc -l)
		mpki_avg=$(echo "scale=10; $mpki_sum / $mpki_count" | bc -l)
		
		# Print average values
		echo "Average IPC: $ipc_avg"
		echo "Average MPKI: $mpki_avg"
		exit 1
	fi

	

	if [[ $3 == plot ]]; then
		input_file="$1$2_stepcount.txt"
		counter=0
		while IFS=: read -r label value rest; do
			if [[ $label == "TD" || $label == "BU" ]]; then
				echo "$counter ${value//[!0-9]} $label" | sed 's/TD/a/g; s/BU/b/g' >> $1_$2_step_result.txt
				echo "$counter ${value//[!0-9]} $label" | sed 's/TD/a/g; s/BU/b/g'
				((counter++))
			fi
		done < "$input_file"
		cat $1$2_stepcount.txt | grep -vE 'START:|END:' | sed 's/TD/a/g' | sed 's/BU/b/g' | awk '{print "("NR-1", "$2")"}'

		sum_total=0
		sum_bottomup=0
		sum_topdown=0

		in=`cat $1$2_stepcount.txt | grep seconds:`

		while read -r line; do
			# Extract the time value from the line
			time=$(echo "$line" | awk '{print $NF}')
			
			# Check the prefix to determine where to add the time value
			if [[ $line == *"topdown:"* ]]; then
				sum_topdown=$(bc <<< "$sum_topdown + $time")
			elif [[ $line == *"bottomup:"* ]]; then
				sum_bottomup=$(bc <<< "$sum_bottomup + $time")
			fi
			
			# Add the time value to the total sum
			sum_total=$(bc <<< "$sum_total + $time")
		done <<< "$in"

		port_bu=$(echo "scale=10; $sum_bottomup / $sum_total" | bc)
		port_td=$(echo "scale=10; $sum_topdown / $sum_total" | bc)

		echo "Total time: $sum_total"
		echo "Time in BU: $sum_bottomup"
		echo "Portion spent in BU: $port_bu"
		echo "Time in TD: $sum_topdown"
		echo "Portion spent in TD: $port_td"

		
		exit 1
	fi

	
	#	lines="0 1"
	if [[ $1 == bfs ]]; then
		lines="52 53 54 55 57 58 76 77 79 96 107 118"
	fi
	if [[ $1 == sssp ]]; then
		lines="109 110 71 72 73 74 75 78 79"
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


