#!/bin/bash

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

hiveportReady=$(ssh root@hadoop-master 'netstat -tuplen' | grep 10000 | wc -l)

# WAIT FOR hive directories to be created
while [ $hiveportReady -ne 1 ]
do
  hiveportReady=$(ssh root@hadoop-master 'netstat -tuplen' | grep 10000 | wc -l)
done

ssh root@hadoop-master './wardenTracker.sh'
ssh root@hadoop-master './wait_for_mapr_hive.sh'
