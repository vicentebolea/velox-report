#!/bin/bash

set -x 
source ./VARS.sh

OUTPUTDIR=${OUTPUTDIR:=runs}

WORKDIR=$BASE/`date +%s`
mkdir -p $WORKDIR

remote_script=$(< ./grep-remote-files.in sed 's|@\(NODES_ARGS\|LOGS_DIR\)@|$\1|g')

ssh $MASTER 'bash -s' <<<"$remote_script" > $WORKDIR/results.csv

./create_report.sh $WORKDIR/results.csv $WORKDIR/report.pdf $WORKDIR/plot.png $WORKDIR/hist.png

evince $WORKDIR/report.pdf
