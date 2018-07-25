#!/bin/bash
cd "$(dirname $0)"

JOB_FILE="$1/last-mr-output.out"
TASKS_FILE="$1/tasks.csv"
JOB_NAME=$(grep -Po 'Running job: job_\K\d+_\d+' $JOB_FILE)

# Remove other jobs records
sed -n -i.bak "/${JOB_NAME}\|task_name/p" $TASKS_FILE 

> ./task-tmp.csv

# Adding type
paste -d ',' $TASKS_FILE <(echo type; grep -Po 'task_\d+_\d+_\K\w' $TASKS_FILE) > ./task-tmp.csv


# Adding block_size
output=$(paste -d ',' ./task-tmp.csv  <(echo block_size; grep -Po ' len: \K\d+' $JOB_FILE; echo 'NA'))

#cat ./task-tmp.csv
Rscript normalize_time.R <<<"$output" > ./task-tmp.csv
Rscript add_job_id.R < ./task-tmp.csv


rm -f ./task-tmp.csv
