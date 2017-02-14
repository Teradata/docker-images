#!/bin/bash

hname=$(hostname)

Services=0

maprcliReady=$(maprcli service list -node $hname | grep 'ERROR (10009)' | wc -l)

# WAIT FOR CLDB TO START
while [ $Services -ne 2 ]
do
if [ $maprcliReady == 1 ]
then
   maprcliReady=$(maprcli service list -node $hname | grep 'ERROR (10009)' | wc -l)
   Services=0
else
   Services=$(maprcli service list -node $hname | grep CLDB |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
fi
done

# WAIT FOR NODEMANAGER TO START
Services=0
while [ $Services -ne 2 ]
do
   Services=$(maprcli service list -node $hname | grep NodeManager |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
done

# WAIT FOR RESOURCEMANAGER TO START
Services=0
while [ $Services -ne 2 ]
do
   Services=$(maprcli service list -node $hname | grep ResourceManager |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
done

# WAIT FOR HIVE METASTORE TO START
Services=0
while [ $Services -ne 2 ]
do
   Services=$(maprcli service list -node $hname | grep HiveMetastore |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
done

# WAIT FOR HIVESERVER2 TO START
Services=0
while [ $Services -ne 2 ]
do
   Services=$(maprcli service list -node $hname | grep HiveServer2 |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
done

# WAIT FOR JOBHISTORYSERVER TO START
Services=0
while [ $Services -ne 2 ]
do
   Services=$(maprcli service list -node $hname | grep JobHistoryServer |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
done

