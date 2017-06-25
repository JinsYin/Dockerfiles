FROM openjdk:8-jdk-alpine
MAINTAINER Jins Yin <jinsyin@gmail.com>

RUN apk add --no-cache bash

ENV JAVA_VERSION=1.8
ENV HBASE_VERSION=1.2.0
ARG HBASE_TARBALL=http://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz

WORKDIR /usr/local
ADD ${HBASE_TARBALL} ./
RUN mv hbase-* hbase

ENV HBASE_HOME=/usr/local/hbase
ENV HBASE_CONF_DIR=${HBASE_HOME}/conf
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk
ENV JRE_HOME=${JAVA_HOME}/jre
ENV CLASS_PATH=${JRE_HOME}/lib
ENV PATH=${PATH}:${HBASE_HOME}/bin:${JAVA_HOME}/bin:${JRE_HOME}/bin

WORKDIR ${HBASE_HOME}

ADD ./clear.sh ./clear.sh
RUN chmod a+x ./clear.sh
RUN ./clear.sh && rm -f ./clear.sh

# 16000: HBase Master API port
# 16010: HBase Master Web UI
# 16020: HBase Regionserver API port
# 16030: HBase Regionserver Web UI
EXPOSE 16000 16010 16020 16030