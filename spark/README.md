# Spark standalone

Spark standalone 也支持高可用哦。


## Build

```bash
$ docker build -t spark:2.0.2 -f Dockerfile .
```

OR

```bash
$ docker build -t spark:2.0.2 -f Dockerfile --build-arg SPARK_TARBALL=spark-2.0.2-bin-hadoop2.7.tgz .
```


## Deployment

- master

```bash
$ docker run -itd --name spark-master -p 6066:6066 -p 7077:7077 -p 8080:8080 spark:2.0.2 master
```

- worker

```bash
$ docker run -itd --name spark-worker --link spark-master:master spark:2.0.2 worker spark://master:7077
```

OR

```bash
$ docker run -itd --name spark-worker spark:2.0.2 worker spark://[MASTER-IP]:[MASTER-POST]
```


## Compose

```bash
$ docker-compose -f docker-compose.yml up -d
$ docker-compose scale worker=2
```


## Issues 

在 alpine 中执行 `bash start-master.sh` 等操作时报错，原因是原生的 `ps` 命令支持不全，需要下载 `procps`。

> https://github.com/gliderlabs/docker-alpine/issues/173
> https://busybox.net/downloads/BusyBox.html#ps
> https://issues.apache.org/jira/browse/SPARK-13587
> https://github.com/apache/spark/pull/13599
> https://github.com/apache/spark/pull/14180