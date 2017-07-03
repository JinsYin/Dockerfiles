FROM alpine:3.5
MAINTAINER Jins Yin <jinsyin@gmail.com>

RUN apk add --no-cache bash tar

COPY ./etcdv2.tar.gz /etcdv2.tar.gz
RUN mkdir /etcdv2 && tar -zxf /etcdv2.tar.gz -C /etcdv2 --strip-components=1

RUN mv /etcdv2/etcd* /usr/bin/ && chmod +x /usr/bin/etcd*

RUN apk del --no-cache tar
RUN rm -rf /etcdv2*

CMD ["bash"]