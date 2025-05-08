#!/bin/bash

# Directory containing the files
input_dir="build/use-case"

echo "\\section{Use Case Descriptions}"

for file in "$input_dir"/*; do
    base_name=$(basename "$file" .tex)
    echo "\\input{$base_name}"
done

echo "\\section{Robustness Diagrams}"

for file in "$input_dir"/*; do
    base_name=$(basename "$file" .tex)
    diargam_file="build/robustness/$base_name.png"
    echo "\\includegraphics[width=\\textwidth]{$diargam_file}"
done

echo "\\section{Sequence Diagrams}"

for file in "$input_dir"/*; do
    base_name=$(basename "$file" .tex)
    diagram_file="reports/sequence/$base_name.png"
    echo "\\includegraphics[width=\\textwidth]{$diagram_file}"
done
