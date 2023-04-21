#!/bin/bash

max=40

for i in `seq 2 $max`
		 do
			 ./cachemissprofiling.sh $1 $2
done
