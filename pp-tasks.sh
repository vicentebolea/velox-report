

JOB_FILE=$1
TASKS_FILE=$(dirname $JOB_FILE)/results.csv

> ./task-tmp.csv

# Adding type
paste -d ',' $TASKS_FILE <(echo type; grep -Po 'task_\d+_\d+_\K\w' $TASKS_FILE) > ./task-tmp.csv


# Adding block_size
output=$(paste -d ',' ./task-tmp.csv  <(echo block_size; grep -Po ' len: \K\d+' $JOB_FILE; echo 'NA'))

#cat ./task-tmp.csv
Rscript normalize_time.R <<<"$output" > ./task-tmp.csv
Rscript add_job_id.R < ./task-tmp.csv


rm -f ./task-tmp.csv
