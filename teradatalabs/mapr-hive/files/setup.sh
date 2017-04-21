#!/bin/bash

# SETUP METASTORE
mysql_install_db

/usr/bin/mysqld_safe &
sleep 10s

echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql
echo "CREATE DATABASE metastore; USE metastore; SOURCE /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-0.13.0.mysql.sql;" | mysql
/usr/bin/mysqladmin -u root password 'root'

killall mysqld
sleep 10s
mkdir /var/log/mysql/
chown mysql:mysql /var/log/mysql/
