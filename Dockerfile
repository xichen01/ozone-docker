# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG OZONE_RUNNER_IMAGE=apache/ozone-runner
FROM ${OZONE_RUNNER_IMAGE}:20241108-jdk17-1

ARG OZONE_VERSION=1.4.0
ARG OZONE_URL="https://www.apache.org/dyn/closer.lua?action=download&filename=ozone/${OZONE_VERSION}/ozone-${OZONE_VERSION}.tar.gz"

WORKDIR /opt
RUN sudo rm -rf /opt/hadoop && curl -LSs -o ozone.tar.gz $OZONE_URL && tar zxf ozone.tar.gz && rm ozone.tar.gz && mv ozone* hadoop

WORKDIR /opt/hadoop
COPY log4j.properties /opt/hadoop/etc/hadoop/log4j.properties
COPY ozone-site.xml /opt/hadoop/etc/hadoop/ozone-site.xml
RUN sudo chown -R hadoop:users /opt/hadoop/etc/hadoop
COPY --chown=hadoop:users start-ozone-all.sh /usr/local/bin/
COPY --chown=hadoop:users docker-compose.yaml /opt/hadoop/
COPY --chown=hadoop:users docker-config /opt/hadoop/
ENV OZONE_CONF_DIR=/etc/hadoop
ENV OZONE_LOG_DIR=/var/log/hadoop
CMD ["/usr/local/bin/start-ozone-all.sh"]
