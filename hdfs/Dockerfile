FROM openjdk:8-jre-alpine
MAINTAINER Jins Yin <jinsyin@gmail.com>

USER root

# Default language
ENV LANG=C.UTF-8

# Install dependencies
RUN apk add --no-cache bash tar

# Version
ENV HADOOP_VERSION=2.7.3
ENV JAVA_VERSION=1.8

# Install hadoop
WORKDIR /usr/local
COPY ./hadoop-${HADOOP_VERSION}.tar.gz ./
# RUN wget http://www.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN mkdir hadoop && tar -zxf hadoop-${HADOOP_VERSION}.tar.gz -C hadoop --strip-components 1

# Environmet variables
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_PREFIX=${HADOOP_HOME}
ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk
ENV PATH=$PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${JAVA_HOME}/bin:${JRE_HOME}/bin

ENV HADOOP_TMP_DIR=/data/hdfs
ENV DFS_NAMENODE_NAME_DIR=${HADOOP_TMP_DIR}/dfs/name
ENV NAMENODE_FORMAT_FORCED=false

RUN apk del --no-cache tar
RUN rm -rf /tmp/*
RUN rm -rf /usr/local/hadoop-${HADOOP_VERSION}.tar.gz
RUN rm -rf ${JAVA_HOME}/*.zip ${JAVA_HOME}/*.txt
RUN rm -f ${HADOOP_HOME}/*.txt
RUN rm -f ${HADOOP_HOME}/bin/*.cmd
RUN rm -f ${HADOOP_HOME}/sbin/*.cmd
RUN rm -f ${HADOOP_HOME}/libexec/*.cmd
RUN rm -rf ${HADOOP_HOME}/share/doc
RUN rm -rf ${HADOOP_HOME}/share/hadoop/httpfs
RUN rm -rf ${HADOOP_HOME}/share/hadoop/kms
RUN rm -rf ${HADOOP_HOME}/share/hadoop/tools
RUN rm -rf ${HADOOP_HOME}/share/hadoop/yarn
RUN rm -rf ${HADOOP_HOME}/share/hadoop/mapreduce
RUN rm -rf ${HADOOP_HOME}/share/hadoop/common/jdiff
RUN rm -rf $(find ${HADOOP_HOME}/share/hadoop -name *test*.jar)
RUN rm -rf $(find ${HADOOP_HOME}/share/hadoop -name *example*.jar)

COPY ./core-site.xml ${HADOOP_CONF_DIR}/core-site.xml
COPY ./docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/docker-entrypoint.sh

WORKDIR ${HADOOP_HOME}

ENTRYPOINT ["docker-entrypoint.sh"]