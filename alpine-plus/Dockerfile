FROM alpine:3.5
MAINTAINER Jins Yin <jinsyin@gmail.com>

RUN apk add --no-cache openjdk8
RUN apk add --no-cache build-base linux-headers pcre-dev python3 python3-dev # python env
RUN apk add --no-cache ca-certificates openssl bash procps tar
RUN pip3 install --upgrade pip setuptools

# glibc
RUN apk add --no-cache libc6-compat

RUN apk add --no-cache libc-dev