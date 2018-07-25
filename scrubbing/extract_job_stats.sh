#!/bin/bash
cd "$(dirname $0)"

OUT_FILE="$1/last-mr-output.out"
INFO_FILE="$1/info.out"

JOB_NAME=$(grep -Po 'Running job: job_\K\d+_\d+' $OUT_FILE)
JOB_EXEC_TIME=$(grep 'real' $OUT_FILE | sed 's/\s\+/ /g' | cut -d ' ' -f 2)
BLOCK_SIZE=$(grep -Po 'BLOCK_SIZE \K\w*' $INFO_FILE)
DFS=$(grep -Po 'DFS \K\w*' $INFO_FILE)
ALPHA=$(grep -Po 'ALPHA \K[0-9.]*' $INFO_FILE)

SPECULATIVE=
if grep -Po 'SPECULATIVE' $INFO_FILE >/dev/null
then
  SPECULATIVE=YES
else
  SPECULATIVE=NO
fi

ZERO_IO=NO

echo $JOB_NAME,$JOB_EXEC_TIME,$BLOCK_SIZE,$DFS,$SPECULATIVE,$ZERO_IO,$ALPHA
