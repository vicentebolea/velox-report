#!/bin/bash

INPUT=$1
OUTPUT=$2
PLOT_PATH=$3
HIST_PATH=$4

STATS=`< $INPUT Rscript ./plot_tasks.R $PLOT_PATH $HIST_PATH`

STATS=`echo -e "$STATS" | sed 's/^[ ]\+//g' | sed 's/[ ]$//g' | sed 's/1st Qu./1stQu./g' | sed 's/3rd Qu./3rdQu/g' | sed 's/[ ]\+/ /g' | sed $'s/Max.$/Max.\\\n--|--|--|--|--|--/g' | tr ' ' '|'`

pandoc -s -o $OUTPUT <<<"eval "echo \"$(cat ./report.template)\""
