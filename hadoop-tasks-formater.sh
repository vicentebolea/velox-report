#!/bin/env bash

INPUT=`pdsh -N -w raven[01-39] -x raven20 'FOLDER=$(ls -t1 /scratch/vicente/yarn/logs/userlogs/ | head -n1); find /scratch/vicente/yarn/logs/userlogs/$FOLDER -name "*000001" -exec cat {}/syslog \;'`

echo 'task_name, start_time, end_time'
join -1 8 -2 8 -t ' ' <(sort -k 8 <(grep 'SCHEDULED to RUNNING' <<<"$INPUT")) <(sort -k 8 <(grep 'RUNNING to SUCCEEDED' <<<"$INPUT")) | cut -d ' ' -f 1,3,16 | sed 's/,[0-9]\{3\}//g' | tr ' ' ','
