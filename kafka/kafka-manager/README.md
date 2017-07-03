# Kafka Manager

Kafka-Manager 是 Yahoo 开源的用于管理 Apache Kafka 的工具。由于 kafka 的版本是 `0.10.0.1`， 所以建议 Kafka-Manager 使用 `1.3.3.6`。

> https://github.com/yahoo/kafka-manager


## Compile

因为编译很慢，所以先编译好在封装成镜像。

```bash
$ wget https://github.com/yahoo/kafka-manager/archive/1.3.3.6.tar.gz -O kafka-manager-1.3.3.6.tar.gz
$ tar -zxvf kafka-manager-1.3.3.6.tar.gz && cd kafka-manager-1.3.3.6
```

```bash
$ ./sbt clean dist # 很慢，如果出错可以 try
$ cp target/universal/kafka-manager-1.3.3.6.zip ./kafka-manager-bin-1.3.3.6.zip
```

## Build

```bash
$ docker build -t kafka-manager:1.3.3.6 -f Dockerfile .
```

OR

```bash
$ docker build -t kafka-manager:1.3.3.6 -f Dockerfile --build-arg KM_ZIPBALL=kafka-manager-bin-1.3.3.6.zip .
```

## Deployment

```bash
$ docker run -itd --name km -p 9000:9000 kafka-manager:1.3.3.6 bin/kafka-manager -Dconfig.file=conf/application.conf -Dkafka-manager.zkhosts=x.x.x.x:2181 -Dhttp.port=9000
```

> http://localhost:9000

## 参考

> https://github.com/sheepkiller/kafka-manager-docker/blob/alpine/Dockerfile