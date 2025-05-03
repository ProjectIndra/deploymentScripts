#!/bin/bash

# Set environment variables for Hadoop
export HADOOP_HOME=/opt/hadoop-3.4.1
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export HADOOP_STREAMING=$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.2.3.jar
export HADOOP_LOG_DIR=$HADOOP_HOME/logs
export PDSH_RCMD_TYPE=ssh

# Set Java Home
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Install Hadoop
cd /opt/
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz
tar -xvzf hadoop-3.4.1.tar.gz
rm -rf hadoop-3.4.1.tar.gz

# Configure hdfs-site.xml
cat <<EOL > $HADOOP_CONF_DIR/hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
 <property>
   <name>dfs.namenode.name.dir</name>
   <value>/hdfs</value>
 </property>
 <property>
   <name>dfs.replication</name>
   <value>1</value>
 </property>
 <property>
   <name>dfs.webhdfs.enabled</name>
   <value>true</value>
 </property>
</configuration>
EOL

# Configure core-site.xml
cat <<EOL > $HADOOP_CONF_DIR/core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration> 
 <property> 
   <name>fs.defaultFS</name> 
   <value>hdfs://0.0.0.0:9000</value>  
 </property> 
 <property>
   <name>hadoop.proxyuser.dataflair.groups</name>
   <value>*</value>
 </property>
 <property>
   <name>hadoop.proxyuser.dataflair.hosts</name>
   <value>*</value>
 </property>
 <property>
   <name>hadoop.proxyuser.server.hosts</name>
   <value>*</value>
 </property>
 <property>
   <name>hadoop.proxyuser.server.groups</name>
   <value>*</value>
 </property>
</configuration>
EOL

# Output success message
echo "Hadoop 3.4.1 has been installed and configuration files have been set."
