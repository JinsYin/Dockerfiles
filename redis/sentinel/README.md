# Redis sentinel

这个镜像基于 [AliyunContainerService/redis-cluster](https://github.com/AliyunContainerService/redis-cluster) 来构建，为了使配置更灵活我增加、修改了一些环境变量。


## Build

```bash
$ docker build -f Dockerfile -t redis-sentinel:3.2.6-alpine .
```

## Deployment

`SENTINEL_QUORUM` 用于设置最少的选举 master 的选举人人数。

```bash
$ docker run -it --name redis-sentinel --link master:redis-master \
 -e REDIS_MASTER=redis-master \
 -e REDIS_MASTER_PORT=6379 \
 -e SENTINEL_PORT=26379 \
 -e SENTINEL_NAME=redissentinel \
 -e SENTINEL_QUORUM=1 \
 -d redis-sentinel:3.2.6-alpine
```

## 参考

> https://github.com/AliyunContainerService/redis-cluster
> https://redis.io/topics/sentinel