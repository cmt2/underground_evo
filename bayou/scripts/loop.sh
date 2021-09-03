#!/bin/bash
# for bio in {4,15}; do
# 	for tree in {6..10}; do
# 		for r in {1..4}; do
#     		mkdir bio${bio}_tree_${tree}_r00${r}
# 		done
# 	done
# done

for file in model*; do 
	basename=$(basename "$file" | cut -f 1 -d '.') # removes multiple file extensions, works as long as there are no . in your filenames
	dir=$(echo "$basename" | sed 's/modelOU_//g') # removes modelOU to get to the directory name component
	mv "$file" "$dir" # moves the file to it's corresponding directory (derived from its own filename)
done