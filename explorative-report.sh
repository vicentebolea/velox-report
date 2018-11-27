#!/bin/bash
if [ -z $1 ]; then
  WORKDIR=$(mktemp -d)
else
  WORKDIR=$1
fi

echo "Using WORKDIR $WORKDIR"

# Get files
bash scraping/fetch-remote-files.bash $WORKDIR

# Get first visualization
bash visualizing/create_report.sh $WORKDIR/tasks.csv $WORKDIR/report.pdf $WORKDIR/plot.png $WORKDIR/hist.png
evince $WORKDIR/report.pdf& 

# Clean jobs data
bash scrubbing/extract_job_stats.sh $WORKDIR > $WORKDIR/jobs.csv

# Clean tasks data
bash scrubbing/pp-tasks.sh $WORKDIR > $WORKDIR/tasks-clean.csv

