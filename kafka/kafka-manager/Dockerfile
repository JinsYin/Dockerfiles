FROM openjdk:8-jdk-alpine
MAINTAINER Jins Yin <jinsyin@gmail.com>

RUN apk add --no-cache bash

ENV JAVA_VERSION=1.8
ARG KM_VERSION=1.3.3.6
ARG KM_ZIPBALL=kafka-manager-bin-${KM_VERSION}.zip

ADD ./${KM_ZIPBALL} /usr/local/
RUN unzip /usr/local/${KM_ZIPBALL} -d /usr/local && rm -f /usr/local/*.zip
RUN mv /usr/local/kafka-manager-* /usr/local/kafka-manager

ENV KM_HOME=/usr/local/kafka-manager
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk
ENV PATH=${PATH}:/${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin

RUN rm -rf ${KM_HOME}/share
WORKDIR ${KM_HOME}