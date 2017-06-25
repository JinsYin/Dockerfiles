FROM openjdk:8-jdk-alpine
MAINTAINER Jins Yin <jinsyin@gmail.com>

RUN apk add --no-cache bash python py-pip

ENV JAVA_VERSION=1.8
ENV PYTHON_VERSION=2.7
ARG HADOOP_VERSION=2.7
ARG SPARK_VERSION=2.0.2
ARG SPARK_TARBALL=http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

WORKDIR /usr/local
ADD ${SPARK_TARBALL} ./
RUN mv spark-* spark

ENV SPARK_HOME=/usr/local/spark
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk
ENV JRE_HOME=${JAVA_HOME}/jre
ENV CLASS_PATH=${JAVA_HOME}/lib
ENV PATH=${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${JAVA_HOME}/bin:${JRE_HOME}/bin

WORKDIR ${SPARK_HOME}

COPY ./clear.sh ./clear.sh
RUN chmod a+x ./clear.sh
RUN ./clear.sh && rm -f ./clear.sh

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod a+x /usr/bin/docker-entrypoint.sh

# 6066: Master REST Port
# 7077:	Master Listen Port
# 8080:	Master Web UI Port
# 8081:	Worker Web UI port
EXPOSE 6066 7077 8080 8081

ENTRYPOINT ["docker-entrypoint.sh"]