#!/bin/sh

# START SSHD AND THE SOCKS PROXY FOR THE HIVE METASTORE
supervisorctl start sshd
supervisorctl start socks-proxy

# CONFIGURE MAPR
/opt/mapr/server/configure.sh -N mycluster -Z localhost -C localhost -HS localhost -no-autostart

# SETUP DISK FOR MAPR BY RUNNING DISKSETUP
/opt/mapr/server/disksetup -M -F /root/disk.txt

# CREATE HIVE PROXY USERS
chmod 755 /opt/mapr/conf/proxy

# START SERVICES
service mapr-zookeeper start
service mapr-warden start

# CONFIGURE HIVE
/opt/mapr/server/configure.sh -R

# WAIT FOR WARDEN TO START ALL THE SERVICES
/root/warden_tracker.sh

# START HTTPFS SERVICES
maprcli node services -name httpfs -action start -nodes $(hostname)

# RUN HDFS COMMANDS
hadoop fs -mkdir /user/root /user/hive /user/hdfs /user/hive/warehouse /var /var/mapr /var/mapr/cluster /var/mapr/cluster/yarn /var/mapr/cluster/yarn/rm /var/mapr/cluster/yarn/rm/staging /var/mapr/cluster/yarn/rm/staging/hive
hadoop fs -chmod 777 /user/hive /user/hdfs /user/hive/warehouse /var/mapr /var/mapr/cluster/yarn/rm/staging/hive
