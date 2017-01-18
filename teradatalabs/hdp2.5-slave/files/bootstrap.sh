#!/bin/bash

# Script executed by supervisord as bootstrap
####

# It manager the hadoop processes startup sequence via
# the systemctl command. This is the only script launched
# at startup by supervisord.

supervisorctl start hdfs-datanode

supervisorctl start yarn-nodemanager

