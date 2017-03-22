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

hiveportReady=$(ssh -o StrictHostKeyChecking=no root@hadoop-master 'netstat -tuplen' | grep 10000 | wc -l)

# WAIT FOR HIVE PORT TO OPEN
while [ $hiveportReady -ne 1 ]
do
  sleep 5s
  hiveportReady=$(ssh -o StrictHostKeyChecking=no root@hadoop-master 'netstat -tuplen' | grep 10000 | wc -l)
done

maprReady=$(ssh -o StrictHostKeyChecking=no root@hadoop-master 'ps -ef | grep wardenTracker.sh' | wc -l)

# WAIT FOR WARDEN TO START ALL SERVICES
while [ $maprReady -ne 2 ]
do
 maprReady=$(ssh -o StrictHostKeyChecking=no root@hadoop-master 'ps -ef | grep wardenTracker.sh' | wc -l)
done

# WAIT FOR HIVE DIRECTORIES TO BE CREATED
ssh -o StrictHostKeyChecking=no root@hadoop-master './wait_for_mapr_hive.sh'

