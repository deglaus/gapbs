# Runs the first rounds of tests

# :P -- precision does not work on laptop
# Works on stationary

echo "Running BFS on Kronecker graph"

sudo perf record -e L1-dcache-load-misses:P -c 100 -g -- sleep 5 ./bfs -g 20 -n 1

"Kronecker" >> bfs.txt
"----------------------" >> bfs.txt
sudo perf annotate --stdio >> bfs.txt

echo "Running BFS on uniform graph"

sudo perf record -e L1-dcache-load-misses:P -c 100 -g -- sleep 5 ./bfs -u 20 -n 1

"Uniform" >> bfs.txt
"----------------------" >> bfs.txt
sudo perf annotate --stdio >> bfs.txt



