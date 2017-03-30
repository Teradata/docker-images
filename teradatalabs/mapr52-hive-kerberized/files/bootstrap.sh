#!/bin/sh


# START SSHD AND THE SOCKS PROXY FOR THE HIVE METASTORE
supervisorctl start sshd
supervisorctl start socks-proxy

# CONFIGURE MAPR
/opt/mapr/server/configure.sh  -N mycluster -Z localhost -C localhost -HS localhost -no-autostart

# SETUP DISK FOR MAPR BY RUNNING disksetup
/opt/mapr/server/disksetup -M -F /root/disk.txt

# CREATE HIVE PROXY USERS
chmod 755 /opt/mapr/conf/proxy

# CONFIGURE HIVE
/opt/mapr/server/configure.sh -R

# ENABLE SECURITY IN MAPR
/opt/mapr/server/configure.sh -secure -genkeys -C localhost -Z localhost -N mycluster -no-autostart

# START KERBEROS SERVICES
/sbin/service krb5kdc start
/sbin/service kadmin start

# START MAPR SERVICES
service mapr-zookeeper start
service mapr-warden start

# WAIT FOR WARDEN TO START ALL  THE SERVICES
sh /root/wardenTracker.sh

# START HTTPFS SERVICES
maprcli node services -name httpfs -action start -nodes $(hostname) 

# CREATE KERBEROS TICKET
kinit -kt /opt/mapr/conf/mapr.keytab mapr/mycluster@LABS.TERADATA.COM

# CREATE MAPR TICKET
maprlogin kerberos -user mapr/mycluster@LABS.TERADATA.COM

# RUN HDFS COMMANDS
hadoop fs -mkdir /user/root /user/hive /user/hdfs /user/hive/warehouse /var /var/mapr /var/mapr/cluster /var/mapr/cluster/yarn /var/mapr/cluster/yarn/rm /var/mapr/cluster/yarn/rm/staging /var/mapr/cluster/yarn/rm/staging/hive
hadoop fs -chmod 777 /user/hive /user/hdfs /user/hive/warehouse /var/mapr /var/mapr/cluster/yarn/rm/staging/hive

# REMOVE MAPR TICKET AND KERBEROS TICKET
kdestroy
rm -rf /tmp/*
