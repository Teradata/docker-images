# Copyright 2017 Teradata
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM teradatalabs/mapr-base
MAINTAINER Teradata Docker Team <docker@teradata.com>

# ADD ALL REQUIRED SCRIPTS AND FILES TO ROOT DIRECTORY
ADD files/setup.sh /root/
ADD files/warden_tracker.sh /root/
ADD files/bootstrap.sh /root/
ADD files/socks-proxy.sh /root/
ADD files/conf/hive-site.xml /opt/mapr/hive/hive-1.2/conf/hive-site.xml
ADD files/conf/core-site.xml /opt/mapr/hadoop/hadoop-2.7.0/etc/hadoop/core-site.xml
COPY files/supervisord.d/mysql-metastore.conf /etc/supervisord.d/
COPY files/supervisord.d/socks-proxy.conf /etc/supervisord.d/
COPY files/supervisord.d/sshd.conf /etc/supervisord.d/

RUN chmod 777 /root/setup.sh /root/warden_tracker.sh /root/bootstrap.sh /root/socks-proxy.sh /root/startup.sh \

# INSTALL MYSQL SERVER
  && yum install -y mysql-server mysql-connector-java \
  && /root/setup.sh \

# INSTALL MAPR HIVE
  && yum install -y mapr-hive mapr-hiveserver2 mapr-hivemetastore \
  && yum -y clean all && rm -rf /tmp/* /var/tmp/* \

# SETUP FLAT FILE /home/mapr/storagefile
  && dd if=/dev/zero of=/home/mapr/storagefile bs=250M count=30 \
# THE /root/disk.txt IS READ BY MapR TO DETERMINE WHICH DISKS IT CAN USE AND THE /home/mapr/storagefile IS A FLAT FILE THAT ACTS AS A DISK
  && echo "/home/mapr/storagefile" > /root/disk.txt

# HDFS PORTS
EXPOSE 5660 6660 5692 5724 5756 6692 6724 6756

# YARN PORTS
EXPOSE 8030 8020 7222 8088 7220 7221 8443 8031 8032 8033 8040 8041 8042 8088 10020 19888

# HIVE PORT
EXPOSE 9083 10000 22

# SOCKS PORT
EXPOSE 1180

CMD /root/startup.sh
