#!/bin/bash
source ./VARS

if [ -z $1 ]; then
  echo $set
  WORKDIR=$(mktemp -d)
else
  WORKDIR=$1
fi

bash ./explorative-report.sh $WORKDIR

head $WORKDIR/jobs.csv

head $WORKDIR/tasks-clean.csv

# initialize job file
if [ ! -f $JOBS_FILE ]; then
  echo "job_id,job_exec_time,block_size,dfs,speculative,zero_io,alpha" > $JOBS_FILE
fi

if [ ! -f $TASKS_FILE ]; then
  echo "task_name,start_time,end_time,type,block_size,diff,experiment" > $TASKS_FILE 
fi

cat $WORKDIR/jobs.csv >> $JOBS_FILE
tail -n +2 $WORKDIR/tasks-clean.csv >> $TASKS_FILE
