#!/bin/bash

if [[ $# == 3  ]]; then
	
	event=L1-dcache-load-misses
	command=record
	
	if [[ $3 == l1 ]]; then
		event=L1-dcache-load-misses	
	elif [[ $3 == llc  ]]; then
		event=mem_load_uops_misc_retired.llc_miss 
		#event=mem_load_uops_misc_retired.llc_miss,offcore_response_all_reads.llc_miss.dram


		# look if llc misses are on OTHER lines of code than L1

		# for llc-miss, bc.cc:125 access out_neighbours whereas bc.cc:126 accesses the successor value of that neighbour. both are l. 36 -- bc.cc:125 gets around 3%; adjust algorithm? add together?
		
		# does offcore_response.all_reads.llc_miss.dram and mem_load_uops_misc_retired.llc_miss have similar values?
		# run with perf stat
		# figure out hit-rate for each instruction for PR
		# try BFS, look if hits and misses are on the same line of code
		# BC - look at l. 37 to see which access causes the most LLC misses.
		# CC - look at l. 8 to see which assembly instruction causes the high miss-rate
		

	elif [[ $3 == full-llc ]]; then
		event=mem_load_uops_misc_retired.llc_miss,offcore_response.all_reads.llc_miss.dram,offcore_response.all_code_rd.llc_miss.dram,offcore_response.all_data_rd.llc_miss.dram,offcore_response.all_pf_code_rd.llc_miss.dram,offcore_response.all_pf_data_rd.llc_miss.dram,offcore_response.all_pf_rfo.llc_miss.dram,offcore_response.all_rfo.llc_miss.dram,offcore_response.any_request.llc_miss_local.dram,offcore_response.data_in_socket.llc_miss.local_dram,offcore_response.data_in_socket.llc_miss_local.any_llc_hit,offcore_response.demand_code_rd.llc_miss.dram,offcore_response.demand_data_rd.llc_miss.dram,offcore_response.demand_ifetch.llc_miss_local.dram,offcore_response.demand_rfo.llc_miss.dram,offcore_response.pf_data_rd.llc_miss_local.dram,offcore_response.pf_ifetch.llc_miss_local.dram,offcore_response.pf_l2_code_rd.llc_miss.dram,offcore_response.pf_l2_data_rd.llc_miss.dram,offcore_response.pf_l2_rfo.llc_miss.dram,offcore_response.pf_l_data_rd.llc_miss_local.dram,offcore_response.pf_l_ifetch.llc_miss_local.dram,offcore_response.pf_llc_code_rd.llc_miss.dram,offcore_response.pf_llc_data_rd.llc_miss.dram,offcore_response.pf_llc_rfo.llc_miss.dram,page_walks.llc_miss 
	fi

		if [[ $2 == uniform ]]; then
			echo "Execute on uniform graph..."	
		else
			
			echo "Execute on Kronecker graph..."
		fi


		echo "Running $1 on $2 graph."
		echo "Monitoring $3 misses using the $command command, monitoring the $event."

		extension=sg
		repeat=40
	
		if [[ $1 == sssp ]]; then
			extension=wsg
			repeat=1
		fi

		sudo perf record -g -e $event:pp --call-graph dwarf  ./$1 -f ./benchmark/$2graph.$extension -n $repeat


		echo $extension
		echo $1
		echo $2
#'sssp.cc:*'

		sudo perf report --sort srcline --stdio | grep -E "$1.cc:*" | sort -k 3  >> $2$1$3.txt

		# if [[ $1 == bfs ]]; then
		# 	echo "-----------------------------------------" >> bfs.txt
		# 	sudo perf report --sort srcline --stdio | grep -E 'bfs.cc:*' | sort -k 3  >> $2bfs.txt

		# elif [[ $1 == sssp  ]]; then
		# 	sudo perf report --sort srcline --stdio | grep -E 'sssp.cc:*' | sort -k 3  >> $2$1.txt
		
			
		# elif [[ $1 == bc ]]; then

		# 	sudo perf report --sort srcline --stdio | grep -E 'bc.cc:*' | sort -k 3  >> $2$1.txt

			
		# elif [[ $1 == pr ]]; then
			
		# 	sudo perf report --sort srcline --stdio | grep -E 'pr.cc:*' | sort -k 3  >> $2$1.txt
			
		# elif [[ $1 == cc ]]; then
			
		# 	sudo perf report --sort srcline --stdio | grep -E 'cc.cc:*' | sort -k 3  >> $2$1.txt
		# elif [[ $1 == tc ]]; then
			
		# 	sudo perf report --sort srcline --stdio | grep -E 'tc.cc:*' | sort -k 3  >> $2$1.txt
			
			
		# else
			
		# 	#		sudo perf report --sort srcline,dso
		# 	echo "OTHER ALGORITHM"
			
		# fi
	
else
    echo "First argument specifies graph algoritm..."
	echo "Second argument specifies graph type; 'kron' or 'uniform'."
	echo "Third argument specified which event to record."
	echo "For example, record L1 cache misses while running bfs on a kronecker graph is done with:"
	echo "./cachemissprofiling.sh bfs kron l1"
	echo "------------------------"
	echo "Available algorithms are the same as in gapbs."
	echo "Available events are currently l1 and llc."
fi

#grep bfs.cc:107 sorted_kronbfs.txt | sed 's/\|/ /'|awk '{print $1}' | sed 's/.$//'
#    	sudo perf record -g -e l2_rqsts.code_rd_miss:pp --call-graph dwarf  ./$1 -f ./benchmark/$2graph.$extension -n $repeat


# r2424 = l2_rqsts.code_rd_miss

