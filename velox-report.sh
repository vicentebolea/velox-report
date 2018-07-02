#!/bin/bash

#set -x 
source ./VARS.sh

OUTPUTDIR=${OUTPUTDIR:-runs}

WORKDIR=$OUTPUTDIR/`date +%s`
mkdir -p $WORKDIR

remote_script=$(< ./grep-remote-files.in templater ./VARS.sh)
echo "$remote_script"

ssh $MASTER 'bash -s' <<<"$remote_script" > $WORKDIR/results.csv

if [[ `wc -l $WORKDIR/results.csv` =~ "^1 " ]] ; then
  echo "Failed to find the AppManager logfile"
  exit 1
fi

./create_report.sh $WORKDIR/results.csv $WORKDIR/report.pdf $WORKDIR/plot.png $WORKDIR/hist.png

evince $WORKDIR/report.pdf
