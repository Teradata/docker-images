#!/bin/bash

hname=$(hostname)

Services=0

maprcliReady=$(maprcli service list -node $hname | grep 'ERROR (10009)' | wc -l)

#wait for CLDB to start
while [ $Services -ne 2 ]
do
if [ $maprcliReady == 1 ]
then
   maprcliReady=$(maprcli service list -node $hname | grep 'ERROR (10009)' | wc -l)
   Services=0
else
   Services=$(maprcli service list -node $hname | grep JobHistoryServer |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
fi
done

#wait for NodeManager to start

Services=0
while [ $Services -ne 2 ]
do
   Services=$(maprcli service list -node $hname | grep NodeManager |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
done

#wait for ResourceManager to start

Services=0
while [ $Services -ne 2 ]
do
   Services=$(maprcli service list -node $hname | grep ResourceManager |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
done

#wait for Hive Metastore to start

Services=0
while [ $Services -ne 2 ]
do
   Services=$(maprcli service list -node $hname | grep HiveMetastore |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
done

#wait for HiveServer2 to start

Services=0
while [ $Services -ne 2 ]
do
   Services=$(maprcli service list -node $hname | grep HiveServer2 |awk '{$1=$1};1' | tr ' ' '\n' | tail -1f)
done



