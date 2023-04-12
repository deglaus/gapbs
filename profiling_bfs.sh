# Runs the first rounds of tests

# :P -- precision does not work on laptop
# Works on stationary

echo "Running BFS on Kronecker graph"

#sudo perf record -e L1-dcache-load-misses -c 100 -g -- sleep 5 ./bfs -g 20 -n 1

#sudo perf record -e L1-dcache-load-misses ./bfs -g 20 -n 1

# Record with high-level instructions; no stack-trace.
sudo perf record -e L1-dcache-load-misses:P ./bfs -f ./benchmark/krongraph.sg


echo "Kronecker" >> bfs.txt
echo "----------------------" >> bfs.txt
sudo perf annotate --stdio >> bfs.txt

# echo "Running BFS on uniform graph"

# sudo perf record -e L1-dcache-load-misses -c 100 -g -- sleep 5 ./bfs -u 20 -n 1

# echo "Uniform" >> bfs.txt
# echo "----------------------" >> bfs.txt
# sudo perf annotate --stdio >> bfs.txt



