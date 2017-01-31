#!/bin/sh

#configure mapr
/opt/mapr/server/configure.sh  -N mycluster -Z localhost -C localhost -HS localhost -no-autostart

#setup disk for mapr
dd if=/dev/zero of=/home/mapr/storagefile bs=1G count=10
/opt/mapr/server/disksetup -M -F /root/disk.txt

#create proxy setup for hive users
chmod 755 /opt/mapr/conf/proxy
touch /opt/mapr/conf/proxy/hive-user
touch /opt/mapr/conf/proxy/hdfs-user

#start zookeeper
service mapr-zookeeper start

#start warden 
service mapr-warden start


#configure hive
/opt/mapr/server/configure.sh -R

#wait for warden to start all the services

sh /root/wardenTracker.sh


#run hdfs commands
hadoop fs -mkdir /user/hive-user
hadoop fs -chmod 777 /user/hive-user
hadoop fs -mkdir /user/hdfs-user
hadoop fs -chmod 777 /user/hdfs-user
hadoop fs -mkdir /user/root
hadoop fs -mkdir /user/hive
hadoop fs -mkdir /user/hive/warehouse
hadoop fs -chmod 777 /user/hive
hadoop fs -chmod 777 /user/hive/warehouse


