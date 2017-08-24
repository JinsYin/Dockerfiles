FROM openjdk:8-jdk-slim
MAINTAINER Jins Yin <jinsyin@gmail.com>

ARG PYTHON_VERSION="3.5"
ARG PYTHON_PACKAGES=""

RUN apt-get -y update

RUN apt-get install -y python3="${PYTHON_VERSION}*" && ln -s /usr/bin/python3 /usr/bin/python
RUN apt-get install -y python3-pip && pip3 install --upgrade pip

# Development tools
# RUN apt-get install -y build-essential libssl-dev libffi-dev python-dev

RUN if [ -n "${PYTHON_PACKAGES}" ]; then pip3 install ${PYTHON_PACKAGES}; fi