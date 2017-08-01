# Copyright 2016 Teradata
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

FROM teradatalabs/centos6-java8-oracle:unlabelled
MAINTAINER Teradata Docker Team <docker@teradata.com>

ARG JDK_PATH

ENV LDAP_PATH=/etc/ldap JAVA_HOME=$JDK_PATH

# Import the Active Directory certificate into presto-coordinator
COPY files $LDAP_PATH/files
RUN keytool -import -alias presto -storepass changeit -keystore $JAVA_HOME/jre/lib/security/cacerts \
    -noprompt -trustcacerts -file $LDAP_PATH/files/active-directory-certificate.crt && \
    rm -rf $LDAP_PATH/files/active-directory-certificate.crt

# Import the Open LDAP certificate into presto-coordinator
RUN keytool -import -alias prestowithopenldap -storepass changeit -keystore $JAVA_HOME/jre/lib/security/cacerts \
    -noprompt -trustcacerts -file $LDAP_PATH/files/openldap-certificate.pem && \
    rm -rf $LDAP_PATH/files/openldap-certificate.pem

# Generate a keystore.
RUN keytool -genkey -alias coordinator -storepass testldap -keystore $LDAP_PATH/coordinator.jks \
    -keypass testldap -keyalg RSA -sigalg SHA1withRSA -dname "CN=presto-master, OU=, O=, L=, S=, C="
# Generate a certificate and CSR for the keystore. CN should match the hostname of presto-coordinator
RUN keytool -export -alias coordinator -storepass testldap -keystore $LDAP_PATH/coordinator.jks \
    -file $LDAP_PATH/coordinator.cer && \
    keytool -certreq -alias coordinator -storepass testldap -keystore $LDAP_PATH/coordinator.jks \
    -file $LDAP_PATH/coordinator.csr

# create a test CA and generate caroot.cer( root certificate of the CA ).
RUN openssl req -new -keyout $LDAP_PATH/cakey.pem -out $LDAP_PATH/careq.pem -nodes \
    -subj "/C=US/ST=Massachusetts/L=Boston/O=Teradata/OU=Finance/CN=teradata" && \
    openssl x509 -req -in $LDAP_PATH/careq.pem -out $LDAP_PATH/caroot.cer -days 3650 \
    -signkey $LDAP_PATH/cakey.pem

# sign the server certificate using the testCA
RUN openssl x509 -req -in $LDAP_PATH/coordinator.csr -out $LDAP_PATH/TestCA.cer -days 365 \
    -CA $LDAP_PATH/caroot.cer -CAkey $LDAP_PATH/cakey.pem -CAserial $LDAP_PATH/files/serial.txt

# Import the caroot.cer to the keystore and replace the previously generated self-signed cert with the new CA signed one in the keystore
# Note: The -alias name (coordinator) should be the same as the alias used when coordinator.cer was generated
RUN keytool -import -alias TestCA -storepass testldap -keystore $LDAP_PATH/coordinator.jks \
    -noprompt -file $LDAP_PATH/caroot.cer && \
    keytool -import -alias coordinator -storepass testldap -keystore $LDAP_PATH/coordinator.jks \
    -file $LDAP_PATH/TestCA.cer

# Import the root certificate of the issuer of the presto-coordinator certificate.
# This would be used by clients ( cli, jdbc ) to run tests
RUN keytool -import -alias caroot -storepass testldap -keystore $LDAP_PATH/cacerts.jks -noprompt \
    -file $LDAP_PATH/caroot.cer
