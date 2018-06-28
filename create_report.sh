#!/bin/env bash

STATS=`cat results.csv | Rscript  ./plot_tasks.R results.png`

PLOT_PATH=./results.png
echo "$STATS"

template="
# VELOXDFS REPORT

## STATS"
template=$template$'\n'${STATS}

template=$template$'\n'"
## CHARTS 
![Time series plot]($PLOT_PATH)
" 

pandoc -s -o report.html <<<"$template"
