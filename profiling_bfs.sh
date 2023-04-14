# Runs the first rounds of tests

# :P -- precision does not work on laptop
# Works on stationary

echo "Running BFS on Kronecker graph"

#sudo perf record -e L1-dcache-load-misses -c 100 -g -- sleep 5 ./bfs -g 20 -n 1

#sudo perf record -e L1-dcache-load-misses ./bfs -g 20 -n 1

# Record with high-level instructions; no stack-trace.
# sudo perf record -e L1-dcache-load-misses:P ./bfs -f ./benchmark/krongraph.sg
# easy to read with perf annotate!


# Record with instructions with stack-trace.

## Using sleep
#  sudo perf record -e L1-dcache-load-misses:P -c 100 -g -- sleep 5 ./bfs -f ./benchmark/krongraph.sg -n 3

# With dwarf -- seems like the most suitable one... it's easy to ready with: sudo perf report --call-graph --stdio
# or just sudo perf report
 sudo perf record -g  -e L1-dcache-load-misses:P --call-graph dwarf ./bfs -f ./benchmark/krongraph.sg


# With dwarf + sleep -- seems to exclusively produce stack traces to the Linux kernel.
#  sudo perf record -g  -e L1-dcache-load-misses:P -c 100 --call-graph dwarf sleep 5  ./bfs -f ./benchmark/krongraph.sg -n 3




# Present results
# sudo perf report --call-graph --stdio
# sudo perf annotate -l --full-paths --source   --stdio

# echo "Kronecker" >> bfs.txt
# echo "----------------------" >> bfs.txt
# sudo perf annotate --stdio >> bfs.txt

 echo "Running BFS on uniform graph"

# sudo perf record -e L1-dcache-load-misses -c 100 -g -- sleep 5 ./bfs -u 20 -n 1
 sudo perf record -g  -e L1-dcache-load-misses:P --call-graph dwarf ./bfs -f ./benchmark/uniformgraph.sg


# echo "Uniform" >> bfs.txt
# echo "----------------------" >> bfs.txt
# sudo perf annotate --stdio >> bfs.txt



