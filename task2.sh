#!/bin/bash

# Ensure the dataset1 directory exists
if [ ! -d "dataset1" ]; then
    echo "Error: dataset1 directory not found."
    exit 1
fi

# Pipeline:
grep -rl "sample" dataset1/* | \
    while read file; do
        count=$(grep -o "CSC510" "$file" | wc -l)
        if [ $count -ge 3 ]; then
            echo "$file:$count"
        fi
    done | \
    gawk -F: '{
        "stat -c%s \"" $1 "\"" | getline size;
        close("stat -c%s \"" $1 "\"");
        print $0 ":" size
    }' | \
    sort -t: -k2,2nr -k3,3nr | \
    cut -d: -f1 | \
    sed 's/file_/filtered_/g' | \
    sed 's|dataset1/||g'
