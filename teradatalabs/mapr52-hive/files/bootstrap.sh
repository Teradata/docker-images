#!/bin/sh

# CONFIGURE MapR
/opt/mapr/server/configure.sh  -N mycluster -Z localhost -C localhost -HS localhost -no-autostart

# SETUP FLAT FILE /home/mapr/storagefile
dd if=/dev/zero of=/home/mapr/storagefile bs=1G count=10

# SETUP DISK FOR MAPR BY RUNNING disksetup
/opt/mapr/server/disksetup -M -F /root/disk.txt

# CREATE HIVE PROXY USERS
chmod 755 /opt/mapr/conf/proxy

# START SERVICES
service mapr-zookeeper start
service mapr-warden start

# CONFIGURE HIVE
/opt/mapr/server/configure.sh -R

# WAIT FOR WARDEN TO START ALL THE SERVICES
sh /root/wardenTracker.sh

# RUN HDFS COMMANDS
hadoop fs -mkdir /user/root /user/hive /user/hive/warehouse
hadoop fs -chmod 777 /user/hive /user/hive/warehouse
