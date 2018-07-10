#!/bin/bash

#set -x 
source ./VARS.sh

OUTPUTDIR=${OUTPUTDIR:-runs}

WORKDIR=$OUTPUTDIR/`date +%s`
mkdir -p $WORKDIR

function get_from_remote () {
  set -x
  local TARGET_FILE=$1
  local REMOTE_FN=$2
  local OUTPUT_FILE=$WORKDIR/$TARGET_FILE
  local FN=$(< $REMOTE_FN templater ./VARS.sh)
  echo "$FN"

  ssh $MASTER 'bash -s' <<<"$FN" > 

  if [[ `wc -l $OUTPUT_FILE` =~ "^1 " ]] ; then
    echo "Failed to find the $TARGET_FILE logfile"
    exit 1
  fi
  set +x
}

# AppManager file
get_from_remote "AM_syslog.log" "grep-remote_files.in"

get_from_remote "job-output.log" "grep-joboutput.in"

# Create tasks.csv
INPUT=$(cat $WORKDIR/AM_syslog.log)
echo 'task_name, start_time, end_time' > $WORKDIR/tasks.csv
join -1 8 -2 8 -t ' ' <(sort -k 8 <(grep 'SCHEDULED to RUNNING' <<<"$INPUT")) <(sort -k 8 <(grep 'RUNNING to SUCCEEDED' <<<"$INPUT")) | cut -d ' ' -f 1,3,16 | sed 's/,[0-9]\\{3\\}//g' | tr ' ' ',' >> $WORKDIR/tasks.csv
