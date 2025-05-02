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

    description_file="reports/use-cases/${use_case}-description.md"
    robustness_file="reports/use-cases/${use_case}-robustness.drawio.png"
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
