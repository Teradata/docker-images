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

# ADD REPO FOR MapR
ADD files/maprtech.repo /etc/yum.repos.d/maprtech.repo
RUN yum update -y \
# ... GET MapRGPG KEY
  && rpm --import http://package.mapr.com/releases/pub/maprgpg.key \

# INSTALL UTILITY SOFTWARE
  && yum install -y iputils vim openssh-server openssh-clients sudo \ 

# CONFIGURE SSH
  && chkconfig sshd on \
  && service sshd start \

# INSTALL MapR 
  && yum install -y mapr-fileserver mapr-nfs mapr-nodemanager  mapr-cldb \ 
  && yum install -y mapr-zookeeper mapr-resourcemanager mapr-historyserver \  
  && yum install -y mapr-webserver  mapr-gateway \

# CONFIGURE ZOOKEEPER'S DATA DIRECTORY
  && rm -rf /opt/mapr/zkdata \
  && mkdir /opt/mapr/zkdata \
  && chmod 777 /opt/mapr/zkdata \
  && mkdir -p /mapr \
# THE /root/disk.txt IS READ BY MapR TO DETERMINE WHICH DISKS IT CAN USE AND THE /home/mapr/storagefile IS A FLAT FILE THAT ACTS AS A DISK
  && echo "/home/mapr/storagefile" > /root/disk.txt \

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
  && ssh-keygen -t rsa -b 4096 -C "automation@teradata.com" -N "" -f /root/.ssh/id_rsa \
  && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \

  && adduser mapr \
  && touch /home/mapr \
  && echo "cd /home/mapr" >> /home/mapr/.bashrc \
