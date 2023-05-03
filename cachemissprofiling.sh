#!/bin/bash

if [[ $# == 3  ]]; then
	
	event=L1-dcache-load-misses
	command=record
	
	if [[ $3 == l1 ]]; then
		event=L1-dcache-load-misses	
	elif [[ $3 == llc  ]]; then
		event=mem_load_uops_misc_retired.llc_miss 
		#event=mem_load_uops_misc_retired.llc_miss,offcore_response_all_reads.llc_miss.dram


		# look if llc misses are on OTHER lines of code than L1 - CHECK

		# for llc-miss, bc.cc:125 access out_neighbours whereas bc.cc:126 accesses the successor value of that neighbour. both are l. 36 -- bc.cc:125 gets around 3%; adjust algorithm? add together?
		
		# does offcore_response.all_reads.llc_miss.dram and mem_load_uops_misc_retired.llc_miss have similar values? - no, offcore gets at least 1.5-4 times as many samples
		# run with perf stat


		
		# figure out hit-rate for each instruction for PR
		## LLC Kron: pr.cc:48 - 2% -
		## - movsql (move sign long quad) moves a value from 32-bit location to a 64-bit register and also sign-extends the value.
		## - movslq (%rax), %rdx - result is stored in rdx
		## - 48.63.10
		## - takes the index v of the for-loop and extends it so that it can be used to access incoming neighbours.
		## - rdx thus holds the incoming neighbour we accessed.

		## LLC Kron: 97% pr.cc:49
		### Using perf annotate: 92.32% - addss (%rsi, %rdx, 4), %xmm0
		# - f3.0f.58.04.96 
		# - single-precision floating-point addition, adds the first argument to the second.
		# - here, the result of %rsi + (%rdx*4) is the memory address i.e. outgoing_contrib[v], the value stored there is added to %xmm0, which is incoming_total.
		# - %rsi has the array's base address.
		# - %rdx has the array index; multiplied by 4 since the elemnts are each 4 bytes.
		# - %xmm0 is a SIMD register holding four 32-bit float-point numbers.
		# - is false sharing possible with addss? multiple threading - multiple updates to elements in pvector, if two or more threads access elements sharing cache line, false sharing can occur.

		# though some times cmp %rax,%r11
		# presumably, it looks at if we are the end of incoming neighbours pvector. since we jne afterwards to updating the index. jne to movslq!

		
		# try BFS, look if hits and misses are on the same line of code
		# BC - look at l. 37 to see which access causes the most LLC misses.
		# CC - look at l. 8 to see which assembly instruction causes the high miss-rate
		

	elif [[ $3 == full-llc ]]; then
		event=mem_load_uops_misc_retired.llc_miss,offcore_response.all_reads.llc_miss.dram,offcore_response.all_code_rd.llc_miss.dram,offcore_response.all_data_rd.llc_miss.dram,offcore_response.all_pf_code_rd.llc_miss.dram,offcore_response.all_pf_data_rd.llc_miss.dram,offcore_response.all_pf_rfo.llc_miss.dram,offcore_response.all_rfo.llc_miss.dram,offcore_response.any_request.llc_miss_local.dram,offcore_response.data_in_socket.llc_miss.local_dram,offcore_response.data_in_socket.llc_miss_local.any_llc_hit,offcore_response.demand_code_rd.llc_miss.dram,offcore_response.demand_data_rd.llc_miss.dram,offcore_response.demand_ifetch.llc_miss_local.dram,offcore_response.demand_rfo.llc_miss.dram,offcore_response.pf_data_rd.llc_miss_local.dram,offcore_response.pf_ifetch.llc_miss_local.dram,offcore_response.pf_l2_code_rd.llc_miss.dram,offcore_response.pf_l2_data_rd.llc_miss.dram,offcore_response.pf_l2_rfo.llc_miss.dram,offcore_response.pf_l_data_rd.llc_miss_local.dram,offcore_response.pf_l_ifetch.llc_miss_local.dram,offcore_response.pf_llc_code_rd.llc_miss.dram,offcore_response.pf_llc_data_rd.llc_miss.dram,offcore_response.pf_llc_rfo.llc_miss.dram,page_walks.llc_miss
	elif [[ $3 == llc-count  ]]; then
		event=offcore_response.all_reads.llc_miss.dram,mem_load_uops_misc_retired.llc_miss 
	fi



		echo "Running $1 on $2 graph."
		echo "Monitoring $3 misses using the $command command, monitoring the $event."

		extension=sg
		repeat=40
	
		if [[ $1 == sssp ]]; then
			extension=wsg
			repeat=1
		fi

		if [[ $3 == llc-count ]]; then
			echo "Counting llc on $2 graph running $1..."
			#sudo perf stat -e $event -x, -o perf_output ./$1 -f ./benchmark/$2graph.$extension -n $repeat | grep llc_miss
	#		sudo perf stat -e mem_load_uops_misc_retired.llc_miss:pp -e insn:0x48,0x63,0x10 -e insn:0xf3,0x0f,0x58,0x04,0x96  ./$1 -f ./benchmark/$2graph.$extension -n $repeat
			sudo perf stat -d -d -d -e offcore_response.all_reads.llc_miss.dram,mem_load_uops_misc_retired.llc_miss:P ./$1 -f ./benchmark/$2graph.$extension -n $repeat 2>&1 | tee missStat.txt
			grep 'offcore_response.all_reads.llc_miss.dram' missStat.txt  | awk '{print $1}' >> numberofmisses$1$2.txt
			grep 'mem_load_uops_misc_retired.llc_miss' missStat.txt  | awk '{print $1}' >> numberofaccesses$1$2.txt
			sudo perf annotate --stdio | grep -e 49ef -e 49f4 -e 49e8 | grep -v 49f7 | awk '{print $1}' >> percentageinstructions$1$2.txt
			# 10.77 :   49e8:   movslq (%rax),%rdx
			# 88.65 :   49ef:   addss  (%rsi,%rdx,4),%xmm0
			# 0.08 :   49f4:   cmp    %rax,%r11



#			sudo perf stat -d -d -d -e offcore_response.all_reads.llc_miss:P ./$1 -f ./benchmark/$2graph.$extension -n $repeat | grep llc_miss >> accessStat.txt

#			sudo perf script -F ip,event -i perf_output | grep "0xADDRESS f3_0f_58_04_96"
			exit 1
		else
			
			echo "Percentage of $3 misses..."
		fi


		sudo perf record -g -e $event:pp --call-graph dwarf  ./$1 -f ./benchmark/$2graph.$extension -n $repeat


		echo $extension
		echo $1
		echo $2

		sudo perf report --sort srcline --stdio | grep -E "$1.cc:*" | sort -k 3  >> $2$1$3.txt

	
	
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

echo "./$1 -f ./benchmark/$2graph.$extension -n $repeat"
