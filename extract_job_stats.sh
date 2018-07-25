
JOB_NAME=$(grep -Po 'Running job: job_\K\d+_\d+' $1)
JOB_EXEC_TIME=$(grep 'real' $1 | sed 's/\s\+/ /g' | cut -d ' ' -f 2)
BLOCK_SIZE=$(grep -Po 'input/\w*_\K\d+(?=mb)' <(realpath $1))
DFS=$(grep -Po 'input/\K[a-z]+(?=_)' <(realpath $1))

SPECULATIVE=
if grep -Po 'speculative' <(realpath $1)
then
  SPECULATIVE=YES
else
  SPECULATIVE=NO
fi


ZERO_IO=
if grep -Po 'zero' <(realpath $1) > /dev/null
then
  ZERO_IO=YES
else
  ZERO_IO=NO
fi

echo $JOB_NAME,$JOB_EXEC_TIME,$BLOCK_SIZE,$DFS,$SPECULATIVE,$ZERO_IO
