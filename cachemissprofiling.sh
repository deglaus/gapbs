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
		## - 
		## - 48.63.10
		## - takes the index v of the for-loop and extends it so that it can be used to access incoming neighbours.
		## - rdx thus holds the incoming neighbour we accessed.

		## LLC Kron: 97% pr.cc:49
		### Using perf annotate: 92.32% - addss (%rsi, %rdx, 4), %xmm0
		# - 49ef
		# - f3.0f.58.04.96
		# - f3 0f 58 04 96
		# - single-precision floating-point addition, adds the first argument to the second.
		# - here, the result of %rsi + (%rdx*4) is the memory address i.e. outgoing_contrib[v], the value stored there is added to %xmm0, which is incoming_total.
		# - %rsi has the array's base address.
		# - %rdx has the array index; multiplied by 4 since the elemnts are each 4 bytes.
		# - %xmm0 is a SIMD register holding four 32-bit float-point numbers.
		# - is false sharing possible with addss? multiple threading - multiple updates to elements in pvector, if two or more threads access elements sharing cache line, false sharing can occur.

		# though some times cmp %rax,%r11
		# - 49f4
		# - 49 39 c3
		# presumably, it looks at if we are the end of incoming neighbours pvector. since we jne afterwards to updating the index. jne to movslq!

		
		# try BFS, look if hits and misses are on the same line of code

		# bfs.cc:53
		# 2.33%
		# mov (%rax,%rdi,8),%rax   
		# Fetches starting INDEX of the vertex' edges. The memory address of the neighbour is computed.

		
		# bfs.cc:53 l. 3.5 or 5.
		# 90%
		# - movslq (%rax),%rsi 
		# -
		# - at the for-loop in BU, it fetches the value of a neighbour vertex.
		# - movslq indicates the data is asigned integer; a key attribute to the fact that a neighbour is accessed.

		# bfs.cc:54 l 3.6 or 6.
		# 4.65%
		# mov (%r15,%rsi,8),%rsi
		# -
		# - returns bitmap value which checks if it is in to_visit or not.
		
		# BC - look at l. 37 to see which access causes the most LLC misses.

		# bc.cc:127 is the line! -             delta_u += (path_counts[u] / path_counts[v]) * (1 + deltas[v]);

 #       :          delta_u += (path_counts[u] / path_counts[v]) * (1 + deltas[v]); 
 # bc.cc:127    9.24 :   4cd3:   48 63 02                movslq (%rdx),%rax
 #         :          pvector<double>::operator[](unsigned long):
 #    0.00 :   4cd6:   49 8b 0a                mov    (%r10),%rcx
 #         :          Brandes(CSRGraph<int, int, true> const&, SourcePicker<CSRGraph<int, int, true> >&, int) [clone ._omp_fn.0]:
 #    0.00 :   4cd9:   f3 0f 5a c9             cvtss2sd %xmm1,%xmm1
 #   28.29 :   4cdd:   f3 41 0f 10 14 80       movss  (%r8,%rax,4),%xmm2
 # bc.cc:127    0.77 :   4ce3:   f2 42 0f 10 04 09       movsd  (%rcx,%r9,1),%xmm0
 # bc.cc:127   38.30 :   4ce9:   f2 0f 5e 04 c1          divsd  (%rcx,%rax,8),%xmm0
 #    0.00 :   4cee:   f3 0f 58 d3             addss  %xmm3,%xmm2
 #    0.00 :   4cf2:   f3 0f 5a d2             cvtss2sd %xmm2,%xmm2
 #    0.00 :   4cf6:   f2 0f 59 c2             mulsd  %xmm2,%xmm0
 #    0.00 :   4cfa:   f2 0f 58 c8             addsd  %xmm0,%xmm1
 #    0.00 :   4cfe:   f2 0f 5a c9             cvtsd2ss %xmm1,%xmm1 

		
		
		# CC - look at l. 8 to see which assembly instruction causes the high miss-rate


		

		

	elif [[ $3 == full-llc ]]; then
		event=mem_load_uops_misc_retired.llc_miss,offcore_response.all_reads.llc_miss.dram,offcore_response.all_code_rd.llc_miss.dram,offcore_response.all_data_rd.llc_miss.dram,offcore_response.all_pf_code_rd.llc_miss.dram,offcore_response.all_pf_data_rd.llc_miss.dram,offcore_response.all_pf_rfo.llc_miss.dram,offcore_response.all_rfo.llc_miss.dram,offcore_response.any_request.llc_miss_local.dram,offcore_response.data_in_socket.llc_miss.local_dram,offcore_response.data_in_socket.llc_miss_local.any_llc_hit,offcore_response.demand_code_rd.llc_miss.dram,offcore_response.demand_data_rd.llc_miss.dram,offcore_response.demand_ifetch.llc_miss_local.dram,offcore_response.demand_rfo.llc_miss.dram,offcore_response.pf_data_rd.llc_miss_local.dram,offcore_response.pf_ifetch.llc_miss_local.dram,offcore_response.pf_l2_code_rd.llc_miss.dram,offcore_response.pf_l2_data_rd.llc_miss.dram,offcore_response.pf_l2_rfo.llc_miss.dram,offcore_response.pf_l_data_rd.llc_miss_local.dram,offcore_response.pf_l_ifetch.llc_miss_local.dram,offcore_response.pf_llc_code_rd.llc_miss.dram,offcore_response.pf_llc_data_rd.llc_miss.dram,offcore_response.pf_llc_rfo.llc_miss.dram,page_walks.llc_miss
		#event=mem_load_uops_misc_retired.llc_miss, offcore_response.all_reads.llc_miss.dram, offcore_response.any_request.llc_miss_local.dram, offcore_response.data_in_socket.llc_miss.local_dram, offcore_response.data_in_socket.llc_miss_local.any_llc_hit, offcore_response.pf_data_rd.llc_miss_local.dram, offcore_response.pf_ifetch.llc_miss_local.dram, offcore_response.pf_l_data_rd.llc_miss_local.dram, offcore_response.pf_l_ifetch.llc_miss_local.dram
	elif [[ $3 == llc-count  ]]; then
		#		event=offcore_response.all_reads.llc_miss.dram,mem_load_uops_misc_retired.llc_miss
		event=mem_load_uops_retired.llc_hit:pp,mem_load_uops_misc_retired.llc_miss
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
		#	sudo perf record -e offcore_response.all_reads.llc_miss.dram,mem_load_uops_misc_retired.llc_miss:P   ./$1 -f ./benchmark/$2graph.$extension -n $repeat
		sudo perf record -g -e $event:pp --call-graph dwarf  ./$1 -f ./benchmark/$2graph.$extension -n $repeat
		#sudo perf script -F comm,pid,tid,time,event,ip,dso,sym >> script$1$2_output.txt
		sudo perf script -F insn,event >> script$1$2_output.txt

		if [[ $1 == pr ]]; then
			# how to find instruction address:
			# 1. use perf annotate --stdio to examine which instruction causes the misses
			#
			# for instance,    89.53 :   49f4:   cmp    %rax,%r11 - here 49f4 is the address.
			#
			# 2. use objdump -d e.g. - objdump -d ./pr -  to find its binary address.
			#
			# for instance objdump -d ./pr | grep 49f4 gives us    49f4: 49 39 c3 cmp    %rax,%r11
			# here, 49 39 c3 is what we were looking for!
			#
			#
			# 1. user perf annotate --asm-raw which gives you binary address directly; e.g. 49 39 c3 is there!
			#
			# 3. add into the for-loop list so that it will be looked for.
			#
			#
			insts=("f3 0f 58 04 96" "49 39 c3" "48 63 10")

		elif [[ $1 == bfs ]]; then
			insts=("48 8b 04 f8" "48 63 30" "49 8b 34 f7")
		elif [[ $1 == bc ]]; then
			insts=("48 63 02" "49 8b 0a" "f3 0f 5a c9" "f3 41 0f 10 14 80" "f2 42 0f 10 04 09" "f2 0f 5e 04 c1" "f3 0f 58 d3" "f3 0f 5a d2" "f2 0f 59 c2" "f2 0f 58 c8" "f2 0f 5a c9")


		fi
		misses=0
		hits=0
		for inst in "${insts[@]}"; do
			echo $inst
			echo "sudo perf script -F insn,event | awk '/mem_load_uops_retired.llc_hit/ && /$inst/ {count++} END {print count}'"
			echo "done"
			
			misses=`sudo perf script -F insn,event | grep 'mem_load_uops_misc_retired.llc_miss:pp:' | grep -c "$inst"`
			
			#				hits=`sudo perf script -F insn,event | awk '/mem_load_uops_retired.llc_hit/ && /$inst/ {count++} END {print count}'`
			hits=`sudo perf script -F insn,event | grep 'mem_load_uops_retired.llc_hit:pp:' | grep -c "$inst"`

			echo $misses
			echo $hits
			
			accesses=$(expr $hits + $misses)

			if [[ $accesses == 0 ]]; then
				rate=0
			else
				rate=$(echo "scale=3; $misses / $accesses" | bc)
				echo "$1.cc - $inst - MISS-COUNT: $misses HIT-COUNT: $hits RATE: $rate" >> $1$2_count_$3.txt
				echo "$1.cc - $inst - MISS-COUNT: $misses HIT-COUNT: $hits RATE: $rate"
			fi
			

			
		done
		echo "------------------------------------------------------------------" >> $1$2_count_$3.txt

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
