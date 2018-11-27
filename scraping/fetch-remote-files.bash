#!/bin/bash
cd "$(dirname $0)"

source ../VARS

TMPDIR=$1

# Get tasks
#APPMANAGERFILE=$(< ./grep-tasks-file.in templater ../VARS)
bash ./fetch-last-tasks-table.bash > $TMPDIR/tasks.csv

# Get info
ssh $MASTER 'bash -s' < ./fetch-joboutput.in > $TMPDIR/info.out

# Get output job
scp $MASTER:~/last-mr-output.out $TMPDIR &> /dev/null
