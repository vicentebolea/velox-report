#!/bin/bash

INPUT=$1
OUTPUT=$2
PLOT_PATH=./plot.png
HIST_PATH=./hist.png

STATS=`< $INPUT Rscript ./plot_tasks.R $PLOT_PATH $HIST_PATH`

STATS=`echo -e "$STATS" | sed 's/^[ ]\+//g' | sed 's/[ ]$//g' | sed 's/1st Qu./1stQu./g' | sed 's/3rd Qu./3rdQu/g' | sed 's/[ ]\+/ /g' | sed $'s/Max.$/Max.\\\n--|--|--|--|--|--/g' | tr ' ' '|'`

template="
# VELOXDFS REPORT
## STATS

${STATS}

## CHARTS 
# Tasks Histogram

![Time series plot]($HIST_PATH)

# Per Task Time series

![Time series plot]($PLOT_PATH)" 

pandoc -s -o $OUTPUT <<<"$template"

rm -f $PLOT_PATH $HIST_PATH
