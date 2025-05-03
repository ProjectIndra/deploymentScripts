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

# Create /hdfs directory and set permissions
mkdir -p /hdfs
chown avinash:avinash /hdfs
chmod 700 /hdfs

# Configure hdfs-site.xml
cat <<EOL > $HADOOP_CONF_DIR/hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

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

# Format HDFS (only if not already formatted)
if [ ! -d /hdfs/current ]; then
  echo "Formatting HDFS NameNode..."
  hdfs namenode -format -force
fi

# Start NameNode with logging
echo "Starting NameNode in background with logging to $HADOOP_LOG_DIR/hdfs.log..."
hdfs namenode >> $HADOOP_LOG_DIR/hdfs.log 2>&1 < /dev/null &

# Output success message
echo "Hadoop 3.4.1 has been installed, configured, HDFS formatted, and NameNode started."
