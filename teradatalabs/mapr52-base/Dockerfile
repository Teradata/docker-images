FROM teradatalabs/centos6-java8-oracle
MAINTAINER Teradata Docker Team <docker@teradata.com>


#Add repo for mapr
ADD files/maprtech.repo /etc/yum.repos.d/maprtech.repo
RUN yum update -y

#install utility softwares
RUN yum install iputils vim openssh-server openssh-clients sudo -y

#configure sshh
RUN chkconfig sshd on
RUN service sshd start

#get maprgpg key
RUN rpm --import http://package.mapr.com/releases/pub/maprgpg.key

#add user and password
RUN adduser mapr
RUN adduser hive-user
RUN usermod --password hive hive-user
RUN adduser hdfs-user
RUN usermod --password hdfs hdfs-user
RUN touch /home/hdfs-user
RUN touch /home/hive-user
RUN echo "cd /home/hive-user" >> /home/hive-user/.bashrc
RUN echo "cd /home/hdfs-user" >> /home/hdfs-user/.bashrc

#install mapr 
RUN yum install mapr-fileserver mapr-nfs mapr-nodemanager  mapr-cldb mapr-zookeeper mapr-resourcemanager mapr-historyserver  mapr-webserver  mapr-gateway -y

#necessary configuration for mapr
RUN rm -rf /opt/mapr/zkdata
RUN mkdir /opt/mapr/zkdata
RUN chmod 777 /opt/mapr/zkdata
RUN mkdir -p /mapr
RUN echo "/home/mapr/storagefile" > /root/disk.txt


#install python
RUN yum install -y python-setuptools \
  && easy_install pip \
  && pip install supervisor \
  && mkdir /etc/supervisord.d/ \
# ... and its missing dependency
  && wget http://dl.fedoraproject.org/pub/epel/6/x86_64/python-meld3-0.6.7-1.el6.x86_64.rpm \
  && rpm -ihv python-meld3-0.6.7-1.el6.x86_64.rpm \
  && rm python-meld3-0.6.7-1.el6.x86_64.rpm \

# Cleanup
  && yum -y clean all && rm -rf /tmp/* /var/tmp/*

RUN ssh-keygen -t rsa -b 4096 -C "automation@teradata.com" -N "" -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
