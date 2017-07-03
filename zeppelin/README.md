# Zepplin

apache/zeppelin:0.7.2

Zeppelin 内部集成了 hive、hbase、pig、spark、r、elasticsearch、cassandra、jdbc、sh、md 等大量解释器。如果不指定解释器，默认使用 scala 版本的 spark 解释器 `%spark` （可以直接使用 `sc` 命令）。如果要使用其他解释器，需要安装相应的环境（比如，要使用 `%r` 解释器，需要确保安装了 R 语言环境），也可以修改配置文件或配置页面来使用远程环境。


## Dockerfile

> https://github.com/apache/zeppelin/blob/master/scripts/docker/zeppelin/bin/Dockerfile

这个镜像除了安装有 Zeppelin 包外，安装有 java、python、r 环境以及一些依赖包。如果觉得语言环境不够，或者依赖包不够，可以基于该镜像添加更多的语言环境和依赖。


## Deployment

```bash
$ docker run -it --name zeppelin -p 8080:8080 \
 -v zeppelin_notebook:/zeppelin/notebook \
 -v zeppelin-local-repo:/zeppelin/local-repo \
 -v zeppelin-run:/zeppelin/run \
 -d apache/zeppelin:0.7.2
```

启动之后，可以在 [interpreter](http://127.0.0.1/#/interpreter) 修改解释器的配置，比如指定远程环境。

## Configuration

要配置 zeppelin，可以在 `conf/zeppelin-env.sh` 中设置环境变量，也可以在 `conf/zeppelin-site.xml` 中设置 java 属性。

在 docker 中启动，可以直接使用环境变量修改配置。如果是修改某个解释器的配置可以在配置页面修改。
```bash
$ docker run -it --name zeppelin -p 9090:9090 \
 -e ZEPPELIN_PORT=9090 \
 -e ZEPPELIN_LOG_DIR='/logs' \
 -e ZEPPELIN_NOTEBOOK_DIR='/notebook' \
 -d apache/zeppelin:0.7.2
```

> https://zeppelin.apache.org/docs/0.7.2/install/configuration.html


## 参考

> https://www.zepl.com/explore
> https://medium.com/apache-zeppelin-stories/official-docker-release-of-apache-zeppelin-finally-94183aa5bc0c
> https:/www.youtube.com/watch?v=_PQbVH_aO5E&feature=youtu.be