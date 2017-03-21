#!/bin/bash

nohup hadoop fs -ls /user/hive/warehouse > hivecliReady.log 2>&1 &
wait
hivecliReady=$(cat hivecliReady.log | grep 'No such file or directory' | wc -l)

# WAIT FOR hive directories to be created
while [ $hivecliReady == 1 ]
do
  nohup hadoop fs -ls /user/hive/warehouse > hivecliReady.log 2>&1 &
  wait
  hivecliReady=$(cat hivecliReady.log | grep 'No such file or directory' | wc -l
)
done
rm -rf hivecliReady.log
