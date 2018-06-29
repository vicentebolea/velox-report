#!/bin/bash

set -x 
source ./VARS.sh

[ -z $BASE ] && BASE=runs

WORKDIR=$BASE/`date +%s`
[ -e $WORKDIR ] || mkdir -p $WORKDIR

remote_script=`cat ./grep-remote-files.in |
  sed "s/;NODES_ARGS;/$NODES_ARGS/g" |
  sed "s|;LOGS_DIR;|$LOGS_DIR|g"`

ssh $MASTER 'bash -s' <<<"$remote_script" > $WORKDIR/results.csv

./create_report.sh $WORKDIR/results.csv $WORKDIR/report.pdf $WORKDIR/plot.png $WORKDIR/hist.png

evince $WORKDIR/report.pdf
