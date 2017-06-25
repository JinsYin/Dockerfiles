FROM openjdk:8-jdk-alpine
MAINTAINER Jins Yin <jinsyin@gmail.com>

USER root
ENV LANG=C.UTF-8

RUN apk add --no-cache bash

ENV JAVA_VERSION=1.8
ENV HADOOP_VERSION=2.7.3
ARG HADOOP_TARBALL=http://www.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

WORKDIR /usr/local
ADD ${HADOOP_TARBALL} ./
RUN mv hadoop-* hadoop

ENV HADOOP_HOME=/usr/local/hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk
ENV JRE_HOME=${JAVA_HOME}/jre
ENV PATH=${PATH}:${JAVA_HOME}/bin:${JRE_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin

COPY ./docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod a+x /usr/bin/docker-entrypoint.sh

WORKDIR ${HADOOP_HOME}

COPY ./clear.sh ./clear.sh
RUN chmod a+x ./clear.sh
RUN rm -f ./clear.sh

ENTRYPOINT ["docker-entrypoint.sh"]