FROM redis:3.2.6-alpine
MAINTAINER Jins Yin <yrqiang@163.com>

# Redis sentinel conf
ADD sentinel.conf /etc/redis/sentinel.conf
RUN chown redis:redis /etc/redis/sentinel.conf

ENV SENTINEL_QUORUM=1
ENV SENTINEL_DOWN_AFTER=30000
ENV SENTINEL_FAILOVER=180000
ENV SENTINEL_NAME=myredis
ENV SENTINEL_PORT=26379
ENV REDIS_MASTER_PORT=6379
ENV REDIS_MASTER=0.0.0.0

COPY sentinel-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/sentinel-entrypoint.sh

EXPOSE $SENTINEL_PORT

ENTRYPOINT ["sentinel-entrypoint.sh"]