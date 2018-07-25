#!/bin/bash
cd "$(dirname $0)"

source ../VARS

TMPDIR=$1

# Get tasks
APPMANAGERFILE=$(< ./grep-tasks-file.in templater ../VARS)
ssh $MASTER 'bash -s' <<<"$APPMANAGERFILE" > $TMPDIR/tasks.csv

# Get info
ssh $MASTER 'bash -s' < ./grep-joboutput.in > $TMPDIR/info.out

# Get output job
scp $MASTER:~/last-mr-output.out $TMPDIR &> /dev/null
