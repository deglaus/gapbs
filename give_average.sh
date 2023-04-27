#!/bin/bash

if [[ $# == 2  ]]; then

	if [[ $1 == bfs ]]; then

		max=0
		for i in 52 53 54 55 57 58 76 77 79 96 107 118; do

			newM=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $newM -gt $max  ]]; then
				max=$newM
			fi			
		done

		echo "The number of samples is:"
		echo $max
		echo "--------------------------------------------------"

		for i in 52 53 54 55 57 58 76 77 79 96 107 118; do
			length=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $length -lt max ]]; then
				echo "xd for"
				echo $i
				diff=$(expr $max - $length + 1)

				echo $diff
				for y in `seq 2 $diff`
				do
					echo "adding zeros to 00.00%     0.00%  $1.cc:$i"
					echo "00.00%     0.00%  $1.cc:$i" >> $2$1.txt
				done
			fi
		
		done

		for i in 52 53 54 55 57 58 76 77 79 96 107 118; do
			echo $1.cc:$i
			answer=`./sort_by_line.sh $1 $2 $1.cc:$i |  awk '{ sum+=$1 }END { print sum/NR }'`
			echo $answer
		done
	fi
	
# SSSP--------------------------------------------------------------------
	if [[ $1 == sssp ]]; then
	
		max=0
		for i in 110 71 72 73 74 75 78 79; do
			
			newM=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $newM -gt $max  ]]; then
				max=$newM
			fi			
		done
		echo "The number of samples is:"
		echo $max
		echo "--------------------------------------------------"
		
		for i in 110 71 72 73 74 75 78 79; do
			length=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $length -lt max ]]; then
				echo "xd for"
				echo $i
				diff=$(expr $max - $length + 1)

				echo $diff
				for y in `seq 2 $diff`
				do
					echo "adding zeros to 00.00%     0.00%  $1.cc:$i"
					echo "00.00%     0.00%  $1.cc:$i" >> $2$1.txt
				done
			fi
		
		done


		for i in 110 71 72 73 74 75 78 79; do
			echo $1.cc:$i
			answer=`./sort_by_line.sh $1 $2 $1.cc:$i |  awk '{ sum+=$1 }END { print sum/NR }'`
			echo $answer
		done

	fi

# BC--------------------------------------------------------------------
	if [[ $1 == bc ]]; then

		max=0
		for i in 54 70 71 73 72 75 76 78 125 126 127 131; do

			newM=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $newM -gt $max  ]]; then
				max=$newM
			fi			
		done
		echo "The number of samples is:"
		echo $max
		echo "--------------------------------------------------"


		for i in 54 70 71 73 72 75 76 78 125 126 127 131; do
			length=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $length -lt max ]]; then
				echo "xd for"
				echo $i
				diff=$(expr $max - $length + 1)

				echo $diff
				for y in `seq 2 $diff`
				do
					echo "adding zeros to 00.00%     0.00%  $1.cc:$i"
					echo "00.00%     0.00%  $1.cc:$i" >> $2$1.txt
				done
			fi
		
		done


		for i in 54 70 71 73 72 75 76 78 125 126 127 131; do
			echo $1.cc:$i
			answer=`./sort_by_line.sh $1 $2 $1.cc:$i |  awk '{ sum+=$1 }END { print sum/NR }'`
			echo $answer
		done

fi
# PR --------------------------------------------------------------------
	if [[ $1 == pr ]]; then

		max=0
		for i in 42 48 49 50 51 52 53; do

			newM=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $newM -gt $max  ]]; then
				max=$newM
			fi			
		done
		echo "The number of samples is:"
		echo $max
		echo "--------------------------------------------------"

		
		for i in 42 48 49 50 51 52 53; do
			length=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $length -lt max ]]; then
				echo "xd for"
				echo $i
				diff=$(expr $max - $length + 1)

				echo $diff
				for y in `seq 2 $diff`
				do
					echo "adding zeros to 00.00%     0.00%  $1.cc:$i"
					echo "00.00%     0.00%  $1.cc:$i" >> $2$1.txt
				done
			fi
		
		done


		for i in 42 48 49 50 51 52 53; do
			echo $1.cc:$i
			answer=`./sort_by_line.sh $1 $2 $1.cc:$i |  awk '{ sum+=$1 }END { print sum/NR }'`
			echo $answer
		done


	fi
# CC --------------------------------------------------------------------
		if [[ $1 == cc ]]; then

		max=0
		for i in 100 107 109 113 125 128 61 147 43 44 45 48 50 51 63 64; do
			
			newM=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $newM -gt $max  ]]; then
				max=$newM
			fi			
		done
		echo "The number of samples is:"
		echo $max
		echo "--------------------------------------------------"


		for i in 100 107 109 113 125 128 61 147 43 44 45 48 50 51 63 64; do
			length=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $length -lt max ]]; then
				echo "xd for"
				echo $i
				diff=$(expr $max - $length + 1)

				echo $diff
				for y in `seq 2 $diff`
				do
					echo "adding zeros to 00.00%     0.00%  $1.cc:$i"
					echo "00.00%     0.00%  $1.cc:$i" >> $2$1.txt
				done
			fi
		
		done


		for i in 100 107 109 113 125 128 61 147 43 44 45 48 50 51 63 64; do
			echo $1.cc:$i
			answer=`./sort_by_line.sh $1 $2 $1.cc:$i |  awk '{ sum+=$1 }END { print sum/NR }'`
			echo $answer
		done
fi

# CC --------------------------------------------------------------------
		if [[ $1 == cc ]]; then
		
		max=0
		for i in 100 107 109 113 125 128 61 147 43 44 45 48 50 51 63 64; do

			newM=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $newM -gt $max  ]]; then
				max=$newM
			fi			
		done
		echo "The number of samples is:"
		echo $max
		echo "--------------------------------------------------"

		
		for i in 100 107 109 113 125 128 61 147 43 44 45 48 50 51 63 64; do
			length=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $length -lt max ]]; then
				echo "xd for"
				echo $i
				diff=$(expr $max - $length + 1)

				echo $diff
				for y in `seq 2 $diff`
				do
					echo "adding zeros to 00.00%     0.00%  $1.cc:$i"
					echo "00.00%     0.00%  $1.cc:$i" >> $2$1.txt
				done
			fi
		
		done


		for i in 100 107 109 113 125 128 61 147 43 44 45 48 50 51 63 64; do
			echo $1.cc:$i
			answer=`./sort_by_line.sh $1 $2 $1.cc:$i |  awk '{ sum+=$1 }END { print sum/NR }'`
			echo $answer
		done


		
		fi


		if [[ $1 == tc ]]; then
		
		max=0
		for i in 56 57 59 60 61 63 64 65 66; do

			newM=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $newM -gt $max  ]]; then
				max=$newM
			fi			
		done
		echo "The number of samples is:"
		echo $max
		echo "--------------------------------------------------"

		for i in 56 57 59 60 61 63 64 65 66; do
			length=`./sort_by_line.sh $1 $2 $1.cc:$i | wc -l`
			if [[ $length -lt max ]]; then
				echo "xd for"
				echo $i
				diff=$(expr $max - $length + 1)

				echo $diff
				for y in `seq 2 $diff`
				do
					echo "adding zeros to 00.00%     0.00%  $1.cc:$i"
					echo "00.00%     0.00%  $1.cc:$i" >> $2$1.txt
				done
			fi
		
		done


		for i in 56 57 59 60 61 63 64 65 66; do
			echo $1.cc:$i
			answer=`./sort_by_line.sh $1 $2 $1.cc:$i |  awk '{ sum+=$1 }END { print sum/NR }'`
			echo $answer
		done


		
		fi	
else
	echo "./given_average alg graph "
fi


