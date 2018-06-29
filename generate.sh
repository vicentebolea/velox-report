#!/bin/bash

set -x 
ssh raven 'bash -s' < ./hadoop-tasks-formater.sh > results.csv

./create_report.sh results.csv report.pdf

evince report.pdf
