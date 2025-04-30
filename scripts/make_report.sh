#!/bin/bash

use_cases=("edit-profile" "rate-user" "report-user" "view-past-rides")
markdown_file="use-cases.md"
pdf_file="use-cases.pdf"

echo "---
mainfont: Noto Sans
title: Use Cases
date: $(date +%Y-%m-%d)
geometry: a4paper,margin=3cm
---
" > "$markdown_file"

echo "# Περιπτώσεις Χρήσης" >> "$markdown_file"

for use_case in "${use_cases[@]}"; do
    echo "Processing $use_case..."

    description_file="reports/${use_case}-description.md"
    robustness_file="reports/${use_case}-robustness.drawio.png"

    # Convert use_case from dash-separated format to capitalized words
    formatted_use_case=$(echo "$use_case" | sed -E 's/(\b|-)([a-z])/ \U\2/g')

    echo "" >> "$markdown_file"
    echo "##$formatted_use_case" >> "$markdown_file"
    echo "" >> "$markdown_file"

    #
    # Description
    #

    echo "" >> "$markdown_file"
    echo "### Περιγραφή" >> "$markdown_file"
    echo "" >> "$markdown_file"

    if [ -f "$description_file" ]; then
        cat "$description_file" >> "$markdown_file"
    else
        echo "Δεν υπάρχει περιγραφή" >> "$markdown_file"
    fi

    echo "" >> "$markdown_file"
    echo "\$\pagebreak\$" >> "$markdown_file"
    echo "" >> "$markdown_file"

    #
    # Robustness
    #

    echo "" >> "$markdown_file"
    echo "### Ανάλυση ευρωστίας" >> "$markdown_file"
    echo "" >> "$markdown_file"

    if [ -f "$robustness_file" ]; then
        echo "![image]($robustness_file)" >> "$markdown_file"
    else
        echo "Δεν υπάρχει διάγραμμα ευρωστίας" >> "$markdown_file"
    fi

    echo "" >> "$markdown_file"
    echo "\$\pagebreak\$" >> "$markdown_file"
    echo "" >> "$markdown_file"
done

# Convert the Markdown file to PDF using pandoc
echo "Generating PDF report..."
if command -v pandoc &> /dev/null; then
    pandoc "$markdown_file" -o "$pdf_file" --pdf-engine=lualatex
    echo "PDF report generated: $pdf_file"
else
    echo "Error: pandoc is not installed. Install it using 'sudo apt install pandoc'."
    exit 1
fi
