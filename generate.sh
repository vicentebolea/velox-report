#!/bin/bash

set -x 
source ./VARS.sh

OUTPUT=report.pdf

remote_script=`cat ./grep-remote-files.in |
  sed "s/;NODES_ARGS;/$NODES_ARGS/g" |
  sed "s|;LOGS_DIR;|$LOGS_DIR|g"`

echo "remote_script"


ssh $MASTER 'bash -s' <<<"$remote_script" > results.csv

./create_report.sh results.csv $OUTPUT

evince $OUTPUT
