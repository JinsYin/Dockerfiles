# Spark base

Spark 基础镜像，主要包括 Openjdk8、Python3 以及一些 Python 包。


## 基础镜像？

对于这个镜像来说，究竟该选择哪个镜像来作为基础镜像呢？ 

* alpine

测试发现，如果选择官方的 `alpine` 及其相关的镜像（如：`python:3.5-alpine`、`openjdk:8-jdk-alpine`）作为基础镜像的话，安装 Python 包将会非常容易出错，而且不得不为 Apline 安装一些基础包（如：build-base 等），所以不推荐使用。

```bash
FROM alpine:3.5
MAINTAINER Jins Yin <jinsyin@gmail.com>

RUN apk add --no-cache build-base linux-headers pcre-dev python3 python3-dev openjdk8 bash
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip

RUN pip install numpy pandas scipy
```

* python

如果选择官方的 `python` 镜像（基于 debian jessie）作为基础镜像的话，需要在此基础上安装 JDK。查看 [Dockerfile](https://github.com/docker-library/python/blob/6ebbaa8a56cdf4021c78e87b3872be3861ac072a/3.5/jessie/slim/Dockerfile) 发现，该镜像是基于源码编译的。推荐的基础镜像 tag：`python:2.7`、`python:2.7-slim`、`python:3.5`、`python:3.5-slim`。

```bash
FROM python:3.5-slim
MAINTAINER Jins Yin <jinsyin@gmail.com>

ENV PYTHON_PACKAGES="numpy pandas"

RUN pip3 install --upgrade pip
RUN pip install ${PYTHON_PACKAGES}

# JDK 8
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN apt-get install oracle-java8-installer
```

* openjdk

如果选择官方的 `openjdk` 镜像（基于 debian jessie）作为基础镜像的话，需要在此基础上安装 python。推荐的基础镜像 tag：`openjdk:8-jdk`、`openjdk:8-jdk-slim`。

**Python 3.5**：

```bash
FROM openjdk:8-jdk-slim
MAINTAINER Jins Yin <jinsyin@gmail.com>

RUN apt-get -y update

RUN apt-get install -y python3 && ln -s /usr/bin/python3 /usr/bin/python
RUN apt-get install -y python3-pip && pip3 install --upgrade pip

# Development tools
# RUN apt-get install -y build-essential libssl-dev libffi-dev python-dev

ARG PYTHON_PACKAGES=""
RUN if [ -n "${PYTHON_PACKAGES}" ]; then pip3 install ${PYTHON_PACKAGES}; fi
```

**Python 2.7**：

```bash
FROM openjdk:8-jdk-slim
MAINTAINER Jins Yin <jinsyin@gmail.com>

RUN apt-get -y update

RUN apt-get install -y python
RUN apt-get install -y python-pip && pip install --upgrade pip

# Development tools
# RUN apt-get install -y build-essential libssl-dev libffi-dev python-dev

ARG PYTHON_PACKAGES=""
RUN if [ -n "${PYTHON_PACKAGES}" ]; then pip install ${PYTHON_PACKAGES}; fi
```


## Build

```bash
$ # 默认的 Java 版本是 1.8，Python 版本是 3.5，并且不会安装任何 Python 包
$ docker build -f Dockerfile -t spark-base:1.8-3.5 .
$
$ # 安装所需的　Python 包（建议指定 tag 的时候按包的字母排序）
$ docker build -f Dockerfile --build-arg PYTHON_PACKAGES="numpy pandas scipy" -t spark-base:1.8-3.5-numpy-pandas-scipy .
```


## 参考

  * [How To Install Python 3 and Set Up a Local Programming Environment on Debian 8](https://www.digitalocean.com/community/tutorials/how-to-install-python-3-and-set-up-a-local-programming-environment-on-debian-8)