#!/bin/bash

mysql_install_db
/usr/bin/mysqld_safe &
sleep 20
/usr/bin/mysqladmin -u root password 'root'
killall mysqld
sleep 10
mkdir /var/log/mysql
