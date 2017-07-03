# Kafka

wurstmeister/kafka:0.10.0.1-2

0.10.0.1 版本存在 bug，在 marathon 中部署出现不明错误。挂载 `/var/run/docker.sock` 的原因是因为封装的镜像依赖 docker 命令，[详情](https://github.com/wurstmeister/kafka-docker/blob/0.10.1.0-2/start-kafka.sh#L9)


## Dockerfile

https://github.com/wurstmeister/kafka-docker/blob/0.10.1.0-2/Dockerfile


## Compose

* 单个 broker

```bash
$ docker-compose -f docker-compose-single-broker.yml up -d
$ jconsole 192.168.111.100:1099
```

* 多个 broker

默认情况，`KAFKA_BROKER_ID=-1` 即 broker id 是随机分配的 。另外，docker-compose.yml 映射到主机的端口也是是随机的。

```bash
$ docker-compose -f docker-compose.yml up -d
$ docker-compose scale kafka=2
```