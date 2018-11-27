#!/bin/bash
cd "$(dirname $0)"

source ../VARS

if [ -z MASTER -o -z PORT ]; then
  echo "MASTER or PORT variable not specified at the VARS file"
  exit 123
fi

PREFIX="http://$MASTER:$JOBHISTORY_PORT/ws/v1/history/mapreduce"

# Get last Application master syslog
JOBID=`curl -s "$PREFIX/jobs" | jq -r '.jobs.job[-1].id'`
FILEPATH=`curl -s "$PREFIX/jobs/$JOBID/jobattempts" | jq -r '.jobAttempts.jobAttempt[].logsLink'`
FILEPATH="${FILEPATH}/syslog?start=0"
INPUT=`curl -s $FILEPATH 2>/dev/null`

# Compute tasks CSV table
echo 'task_name, start_time, end_time'
join -1 8 -2 8 -t ' ' <(sort -k 8 <(grep 'SCHEDULED to RUNNING' <<<"$INPUT")) <(sort -k 8 <(grep 'RUNNING to SUCCEEDED' <<<"$INPUT")) | cut -d ' ' -f 1,3,16 | sed 's/,[0-9]\{3\}//g' | tr ' ' ','
