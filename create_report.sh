#!/bin/bash

INPUT=$1
OUTPUT=$2
PLOT_PATH=$3
HIST_PATH=$4

STATS=`< $INPUT Rscript ./plot_tasks.R $PLOT_PATH $HIST_PATH`

STATS=`echo -e "$STATS" | sed 's/^[ ]\+//g;s/[ ]$//g' | sed 's/1st Qu./1stQu./g;s/3rd Qu./3rdQu/g' | sed 's/[ ]\+/ /g' | sed $'s/Max.$/Max.\\\n--|--|--|--|--|--/g' | sed 's/$/\\\n/g' | tr ' ' '|'`


RULES="
PLOT_PATH=$PLOT_PATH
HIST_PATH=$HIST_PATH
STATS=\"`echo -n $STATS`\"
"

echo "$RULES" > rules

templater rules < report.template | pandoc -s -o $OUTPUT 

rm rules
