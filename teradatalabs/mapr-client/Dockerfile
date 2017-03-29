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

ADD files/maprtech.repo /etc/yum.repos.d/maprtech.repo
RUN yum update -y \
  && yum install -y mapr-client.x86_64
