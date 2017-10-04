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

FROM teradatalabs/centos6-java8-oracle
MAINTAINER Teradata Docker Team <docker@teradata.com>

# ADD MAPR REPO
ADD files/maprtech.repo /etc/yum.repos.d/maprtech.repo
COPY files/id_rsa.pub /root/

RUN yum update -y \

# ... GET MapRGPG KEY
  && rpm --import http://package.mapr.com/releases/pub/maprgpg.key \

# INSTALL UTILITY SOFTWARE
  && yum install -y iputils openssh-server openssh-clients sudo lsof \
# CONFIGURE SSH
  && chkconfig sshd on \
  && grep -rl '#Port 22'  /etc/ssh/sshd_config | xargs sed -i 's/#Port 22/Port 22/g' \
  && service sshd start \

# INSTALL MAPR 
  && yum install -y mapr-fileserver mapr-nfs mapr-nodemanager  mapr-cldb \ 
  && yum install -y mapr-zookeeper mapr-resourcemanager mapr-historyserver \  
  && yum install -y mapr-webserver  mapr-gateway mapr-httpfs \

# ADD USERS AND CHANGE OWNERSHIPS
  && adduser mapr \
  && adduser hive \
  && adduser hdfs \
  && touch /home/mapr /home/hive /home/hdfs  \
  && echo "cd /home/mapr" >> /home/mapr/.bashrc \
  && echo "cd /home/hive" >> /home/hive/.bashrc \
  && echo "cd /home/hdfs" >> /home/hdfs/.bashrc \
  && chown -R mapr:mapr /home/mapr /opt/mapr/httpfs \
  && chown hive:hive /home/hive \
  && chown hdfs:hdfs /home/hdfs \
# CONFIGURE ZOOKEEPER'S DATA DIRECTORY
  && rm -rf /opt/mapr/zkdata \
  && mkdir /opt/mapr/zkdata \
  && chmod 777 /opt/mapr/zkdata \
  && mkdir -p /mapr \

# INSTALL PYTHON AND SUPERVISORD
  && yum install -y python-setuptools \
  && easy_install pip \
  && pip install supervisor \
  && mkdir /etc/supervisord.d/ \
# ... AND ITS MISSING DEPENDENCY
  && wget http://dl.fedoraproject.org/pub/epel/6/x86_64/python-meld3-0.6.7-1.el6.x86_64.rpm \
  && rpm -ihv python-meld3-0.6.7-1.el6.x86_64.rpm \
  && rm python-meld3-0.6.7-1.el6.x86_64.rpm \

# CLEANUP
  && yum -y clean all && rm -rf /tmp/* /var/tmp/* \

# GENERATE SSH KEYS
  && ssh-keygen -t rsa -b 4096 -C "automation@teradata.com" -N "" -f /root/.ssh/id_rsa \
  && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
  && cat /root/id_rsa.pub | cat >>  ~/.ssh/authorized_keys

# Copy supervisord startup script and base configs
COPY files/startup.sh /root/startup.sh
COPY files/supervisord.conf /etc/supervisord.conf
COPY files/supervisord.d/bootstrap.conf /etc/supervisord.d/bootstrap.conf

# Add supervisord configs in child images
ONBUILD COPY files/supervisord.d/* /etc/supervisord.d/
