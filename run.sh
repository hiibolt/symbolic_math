#!/bin/sh

# Combine all .bend files in the /src directory and its subdirectories into _main.bend in alphabetical order
find ./src -type f -name "*.bend" | sort -r | while read -r file; do
    echo "# From $file" >> ./_main.bend
    cat "$file" >> ./_main.bend
    echo >> ./_main.bend
    echo >> ./_main.bend
    echo >> ./_main.bend
done

# Execute the _main.bend file with run_bend
bend run-c ./_main.bend

# Clean up the _main.bend file
rm ./_main.bend