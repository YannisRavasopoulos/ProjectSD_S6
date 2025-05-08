#!/bin/bash

# Directory containing the files
input_dir="build/use-case"

echo "\\section{Use Case Descriptions}"

for file in "$input_dir"/*; do
    base_name=$(basename "$file" .tex)
    tex_file="build/use-case/$base_name.tex"
    if [[ -f "$tex_file" ]]; then
        echo "\\input{$tex_file}"
    fi
done

echo "\\section{Robustness Diagrams}"

for file in "$input_dir"/*; do
    base_name=$(basename "$file" .tex)
    diagram_file="build/robustness/$base_name.png"

    md_file="reports/use-case/$base_name.md"
    title=$(head -n 1 "$md_file" | cut -c 4-)
    echo "\\subsection{$title}"

    if [[ -f "$diagram_file" ]]; then
        echo "\\includegraphics[width=\\textwidth]{$diagram_file}"
    else
        echo "No diagram found for $base_name"
    fi
done

echo "\\section{Sequence Diagrams}"

for file in "$input_dir"/*; do
    base_name=$(basename "$file" .tex)
    diagram_file="build/sequence/$base_name.png"

    md_file="reports/use-case/$base_name.md"
    title=$(head -n 1 "$md_file" | cut -c 4-)
    echo "\\subsection{$title}"

    if [[ -f "$diagram_file" ]]; then
        echo "\\includegraphics[width=\\textwidth]{$diagram_file}"
    else
        echo "No diagram found for $base_name"
    fi
done
