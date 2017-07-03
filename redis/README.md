# Redis

redis:3.2.6-alpine


## Dockerfile

官方镜像默认挂载 `/data`，如果不持久化会生成随机的卷名。对于有些不需要持久化 redis 数据的情况，没有必要挂载卷。所以，我删除了 `VOLUME /data` 和 `EXPOSE 6379`，并将基础镜像改为了 `apline:3.5`，等等。

> https://github.com/docker-library/redis/blob/master/3.2/alpine/Dockerfile
> https://github.com/docker-library/redis/commit/2e14b84ea86939438834a453090966a9bd4367fb
> https://github.com/docker-library/redis/blob/2e14b84ea86939438834a453090966a9bd4367fb/3.2/alpine/Dockerfile


## Build

```bash
$ docker build -f Dockerfile -t redis:3.2.6-alpine .
```


## Redis sentinel

Redis sentinel 负责在 redis master 挂掉的时候重新从 redis slave 中选举新的 master。Sentinel 选举人的数量可以通过 `-e SENTINEL_QUORUM` 来设置（默认我设置为了 `1`），必须不能少于这个数字才能进行选举，且应该是奇数个。另外，master 的只需要一个就可以了。[详情](./sentinel/README.md)


## Deployment

```bash
$ docker run -it --name redis -p -d 6379:6379 [-v redis-data:/data] redis:3.2.6-alpine redis-server --appendonly yes
```

OR

```bash
$ docker-compose -f docker-compose.yml up -d
$ docker-compose scale slave=3
$ docker-compose scale sentinel=3
```


## Client

* 连接 master 、slave

```bash
$ docker run -it --rm redis:3.2.6-alpine redis-cli -h [REDIS-IP] -p 6379 info
```

* 连接 sentinel

```bash
$ docker run -it --rm redis:3.2.6-alpine redis-cli -h [REDIS-SENTINEL-IP] -p 26379 info
```
