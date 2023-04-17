echo "Ensuring compiled executables."
# Compile & test
make
make test

echo "Generating graphs..."
# Generate graphs
./converter -g 20 -b ./benchmark/krongraph.sg
./converter -u 20 -b ./benchmark/uniformgraph.sg 
echo "Done!"
echo "Stored in benchmark directory."
