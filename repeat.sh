#!/bin/bash

max=60

for i in `seq 2 $max`
		 do
			 echo "-----------------------"
			 echo "Repeating number $i"
			 echo "-----------------------"
			 ./cachemissprofiling.sh $1 $2 $3
done
