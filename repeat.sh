#!/bin/bash

max=200

for i in `seq 2 $max`
		 do
			 echo "-----------------------"
			 echo "Repeating number $i"
			 echo "-----------------------"
			 ./cachemissprofiling.sh $1 $2 $3
done
