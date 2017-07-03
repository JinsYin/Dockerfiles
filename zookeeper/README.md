# Zookeeper

zookeeper:3.4.9


## Dockerfile

> https://github.com/31z4/zookeeper-docker/blob/master/3.4.10/Dockerfile


## Deployment

* 单实例

```bash
$ docker run -itd --name some-zookeeper --restart always -p 2181:8181 zookeeper:3.4.9
```

* 伪分布式

```bash
$ docker-compose -f docker-compose.yml up -d
```


## Connection

```bash
$ docker run -it --rm --link some-zookeeper:zookeeper zookeeper:3.4.9 zkCli.sh -server zookeeper:2181
```


## Web UI

netflixoss/exhibitor:1.5.2

```bash
$ docker run -it --name exhibitor -p 8080:8080 netflixoss/exhibitor:1.5.2
```