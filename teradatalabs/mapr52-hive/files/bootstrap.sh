#!/bin/sh

# CONFIGURE MAPR
/opt/mapr/server/configure.sh  -N mycluster -Z localhost -C localhost -HS localhost -no-autostart

# SETUP DISK FOR MAPR
dd if=/dev/zero of=/home/mapr/storagefile bs=1G count=10
/opt/mapr/server/disksetup -M -F /root/disk.txt

# CREATE HIVE PROXY USERS
chmod 755 /opt/mapr/conf/proxy

# START ZOOKEEPER
service mapr-zookeeper start

# START WARDEN 
service mapr-warden start

# CONFIGURE HIVE
/opt/mapr/server/configure.sh -R

# WAIT FOR WARDEN TO START ALL THE SERVICES
sh /root/wardenTracker.sh

# RUN HDFS COMMANDS
hadoop fs -mkdir /user/root /user/hive /user/hive/warehouse
hadoop fs -chmod 777 /user/hive /user/hive/warehouse
