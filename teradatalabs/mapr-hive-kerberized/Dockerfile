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

FROM teradatalabs/mapr-hive
MAINTAINER Teradata Docker Team <docker@teradata.com>

# REMOVE UNNECESSARY FILES
RUN rm -rf /opt/mapr/conf/ssl_truststore \
  && rm -rf /opt/mapr/conf/maprserverticket \
  && rm -rf /opt/mapr/conf/cldb.key \
  && rm -rf /opt/mapr/conf/ssl_keystore \
  && rm -rf /root/bootstrap.sh /root/warden_tracker.sh \
  
# INSTALL KERBEROS
  && yum install -y krb5-libs krb5-server krb5-workstation

# ADD KERBEROS CONFIGURATION
ADD files/bootstrap.sh /root/
ADD files/warden_tracker.sh /root/
ADD files/kerberos/krb5.conf /etc/krb5.conf
ADD files/kerberos/kdc.conf /var/kerberos/krb5kdc/kdc.conf
ADD files/kerberos/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl
ADD files/jceJars/local_policy.jar /usr/java/jdk1.8.0_102/jre/lib/security/local_policy.jar
ADD files/jceJars/US_export_policy.jar /usr/java/jdk1.8.0_102/jre/lib/security/US_export_policy.jar

# ENABLE HIVE SECURITY
ADD files/conf/hive-site.xml /opt/mapr/hive/hive-1.2/conf/hive-site.xml

# CREATE KERBEROS DATABASE
RUN /usr/sbin/kdb5_util create -s -P password \
  && usermod -g root hdfs \
  && usermod -g mapr hdfs \

# CREATE MAPR AND HIVE PRINCIPALS AND KEYTABS
  && /usr/sbin/kadmin.local -q "addprinc -randkey mapr/mycluster@LABS.TERADATA.COM" \
  && /usr/sbin/kadmin.local -q "xst -norandkey -k /opt/mapr/conf/mapr.keytab mapr/mycluster@LABS.TERADATA.COM" \
  && /usr/sbin/kadmin.local -q "addprinc -randkey hive/mycluster@LABS.TERADATA.COM" \
  && /usr/sbin/kadmin.local -q "xst -norandkey -k /opt/mapr/conf/hive.keytab hive/mycluster@LABS.TERADATA.COM" \
  
# CREATE HDFS USER
  && /usr/sbin/kadmin.local -q "addprinc -randkey hdfs/mycluster@LABS.TERADATA.COM" \
  && /usr/sbin/kadmin.local -q "xst -norandkey -k /opt/mapr/conf/hdfs.keytab hdfs/mycluster@LABS.TERADATA.COM" \
  
# CHANGE THE PERMISSIONS AND OWNERSHIPS FOR KEYTABS
  && chmod 644  /opt/mapr/conf/hive.keytab /opt/mapr/conf/mapr.keytab /opt/mapr/conf/hdfs.keytab \
  && chmod 777 /root/bootstrap.sh /root/warden_tracker.sh \
  && chown mapr:mapr /opt/mapr/conf/mapr.keytab \
  && chown hive:hive /opt/mapr/conf/hive.keytab \
  && chown hdfs:hdfs /opt/mapr/conf/hdfs.keytab \

# CREATE PRESTO PRINCIPAL AND KEYTAB
  && /usr/sbin/kadmin.local -q "addprinc -randkey presto-server/presto-master.docker.cluster@LABS.TERADATA.COM" \
  && /usr/sbin/kadmin.local -q "addprinc -randkey presto-client/presto-master.docker.cluster@LABS.TERADATA.COM" \
  && /usr/sbin/kadmin.local -q "addprinc -randkey hive/presto-master.docker.cluster@LABS.TERADATA.COM" \
  && mkdir -p /etc/presto/conf \
  && /usr/sbin/kadmin.local -q "xst -norandkey -k /etc/presto/conf/presto-server.keytab presto-server/presto-master.docker.cluster" \
  && /usr/sbin/kadmin.local -q "xst -norandkey -k /etc/presto/conf/presto-client.keytab presto-client/presto-master.docker.cluster" \
  && /usr/sbin/kadmin.local -q "xst -norandkey -k /etc/presto/conf/hive-presto-master.keytab hive/presto-master.docker.cluster" \
  && chmod 644 /etc/presto/conf/*.keytab \
  && cat /opt/mapr/conf/env.sh | sed -e '0,/MAPR_HIVE_SERVER_LOGIN_OPTS="-Dhadoop.login=maprsasl_keytab"/ s/MAPR_HIVE_SERVER_LOGIN_OPTS="-Dhadoop.login=maprsasl_keytab"/MAPR_HIVE_SERVER_LOGIN_OPTS="-Dhadoop.login=hybrid"/' > env_new.sh \
  && cat env_new.sh | sed -e '0,/MAPR_HIVE_LOGIN_OPTS="-Dhadoop.login=maprsasl"/ s/MAPR_HIVE_LOGIN_OPTS="-Dhadoop.login=maprsasl"/MAPR_HIVE_LOGIN_OPTS="-Dhadoop.login=hybrid"/' > /opt/mapr/conf/env.sh \
  && rm -rf env_new.sh

# CREATE SSL KEYSTORE
RUN keytool -genkeypair \
    -alias presto \
    -keyalg RSA \
    -keystore /etc/presto/conf/keystore.jks \
    -keypass password \
    -storepass password \
    -dname "CN=presto-master, OU=, O=, L=, S=, C="
RUN chmod 644 /etc/presto/conf/keystore.jks

# EXPOSE KERBEROS PORTS
EXPOSE  88
EXPOSE  749

CMD /root/startup.sh
