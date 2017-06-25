#!/bin/bash
# Author: Jins Yin <yrqiang@163.com>

HBASE_VERSION=1.2.0

# Download
if [ ! -f hbase-${HBASE_VERSION}-src.tar.gz ]; then
	wget http://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-src.tar.gz
fi
mkdir -p hbase && tar -zxf hbase-${HBASE_VERSION}-src.tar.gz -C hbase --strip-components 1

cd hbase

# Modify file
cp ../feature/HConstants.java hbase-common/src/main/java/org/apache/hadoop/hbase/HConstants.java
cp ../feature/ServerManager.java hbase-server/src/main/java/org/apache/hadoop/hbase/master/ServerManager.java
cp ../feature/HRegionServer.java hbase-server/src/main/java/org/apache/hadoop/hbase/regionserver/HRegionServer.java

# Compile HBase (https://hbase.apache.org/book.html#eclipse.commandline)
mvn clean install -DskipTests assembly:single

cp hbase-assembly/target/hbase-${HBASE_VERSION}-bin.tar.gz ../myhbase-${HBASE_VERSION}-bin.tar.gz

cd ../ && rm -r hbase
