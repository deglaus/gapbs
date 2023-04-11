# Runs the first rounds of tests


echo "Running BFS"

sudo perf record -e L1-dcache-load-misses:P -c 100 -g -- sleep 5 ./bfs -g 20 -n 1

# sudo perf annotate --stdio
sudo perf script --header


