#!/bin/bash

#Wait for hadoop-master to be available
conn=0
while [ $conn -ne 1 ]
do
 ping -c 4 -q hadoop-master
 if [ "$?" -eq 0 ]; then
   conn=1
 else
   conn=0
 fi
done

# Wait for hive and warehouse directories in HDFS
hivecliReady=1
while [ $hivecliReady -ne 0 ]
do
  sleep 5s
  ssh -o StrictHostKeyChecking=no root@hadoop-master 'hadoop fs -ls /user/hive/warehouse'
  hivecliReady=$?
done
