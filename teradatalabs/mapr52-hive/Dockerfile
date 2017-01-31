FROM teradatalabs/mapr52-base
MAINTAINER Teradata Docker Team <docker@teradata.com>

#add all required scripts  to root
ADD files/*.sh /root/
ADD files/conf/hive-site.xml /opt/mapr/hive/hive-1.2/conf/hive-site.xml
ADD files/conf/core-site.xml /opt/mapr/hadoop/hadoop-2.7.0/etc/hadoop/core-site.xml
ADD files/conf/supervisord.conf /etc/supervisord.conf
RUN chmod 777 /root/*.sh
COPY files/supervisord.d/* /etc/supervisord.d/
RUN yum install openssh -y

#install mysql server and required software
RUN yum install -y mysql-server mysql-connector-java \
    && yum -y clean all && rm -rf /tmp/* /var/tmp/* 

#install lsof
RUN yum install -y lsof

# RUN SETUP script
RUN /root/setup.sh


#install hive
RUN yum install mapr-hive mapr-hiveserver2 mapr-hivemetastore -y
RUN yum -y clean all && rm -rf /tmp/* /var/tmp/*


# HDFS PORTS
EXPOSE 1004 1006 8020 50010 50020 50070 50075 50470

# YARN PORTS
EXPOSE 8030 8031 8032 8033 8040 8041 8042 8088 10020 19888

# HIVE PORT
EXPOSE 9083 10000

# SOCKS PORT
EXPOSE 1180

#run startup script
CMD /root/startup.sh
