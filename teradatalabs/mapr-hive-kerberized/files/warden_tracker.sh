#!/bin/bash

HOSTNAME=$(hostname)
MAPR_LOGIN_READY=1
MAPR_CLI_READY=$(maprcli service list -node $HOSTNAME | grep 'ERROR (10009)' | wc -l)

# CHECK RUNNING STATUS OF GIVEN SERVICES USING MAPRCLI
function exposes_mapr_services {
 SERVICES=0
 while [ $SERVICES -ne 2 ]
 do
   SERVICES=$(maprcli service list -node $HOSTNAME | grep $1 | awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
 done
}

# WAIT FOR MAPRCLI
while [ $MAPR_CLI_READY == 1 ]
do
  MAPR_CLI_READY=$(maprcli service list -node $HOSTNAME | grep 'ERROR (10009)' | wc -l)
  if [ $MAPR_LOGIN_READY -ne 0 ]
   then
     # CREATE KERBEROS TICKET
     kinit -kt /opt/mapr/conf/mapr.keytab mapr/mycluster@LABS.TERADATA.COM
       
     # CREATE MAPR TICKET
     maprlogin kerberos -user mapr/mycluster@LABS.TERADATA.COM
     MAPR_LOGIN_READY=$?
   fi
done  

# WAIT FOR MAPR SERVICES TO START
exposes_mapr_services CLDB
exposes_mapr_services NodeManager
exposes_mapr_services ResourceManager
exposes_mapr_services HiveMetastore
exposes_mapr_services HiveServer2
exposes_mapr_services JobHistoryServer
