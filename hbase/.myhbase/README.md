# HBase

使用 ip 地址代替 hostname 注册服务到 zookeeper。

## 编译

```bash
$ java -version # 1.8.0_121
```

```bash
$ mvn -version # 3.3.9
```

```bash
$ cd .myhbase
$ ./compile-hbase.sh
```

## 构建

```bash
# myhbase-1.2.0-bin.tar.gz 是修改源码重新编译的
$ cd ..
$ docker build -t myhbase:1.2.0 --build-arg HBASE_TARBALL=.myhbase/myhbase-1.2.0-bin.tar.gz .
```

## Deployment

（确保 master 和 master-backup 在不同的机器上）

- master

```bash
$ docker run -itd --name hbase-master --net=host myhbase:1.2.0 hbase master -Dhbase.master.port=16000 -Dhbase.master.info.port=16010 -Dhbase.zookeeper.quorum=master.mesos:2181 -Dzookeeper.znode.parent=/myhbase -Dhbase.rootdir=hdfs://namenode.hdfs.marathon.mesos:9000/myhbase -Dhbase.cluster.distributed=true -Dhbase.server.ip.enabled=true start
```

- master-backup

```bash
$ docker run -itd --name hbase-backup --net=host myhbase:1.2.0 hbase master  -Dhbase.master.port=16000 -Dhbase.master.info.port=16010 -Dhbase.zookeeper.quorum=master.mesos:2181 -Dzookeeper.znode.parent=/myhbase -Dhbase.rootdir=hdfs://namenode.hdfs.marathon.mesos:9000/myhbase -Dhbase.cluster.distributed=true -Dhbase.server.ip.enabled=true --backup start
```

- regionserver

```bash
$ docker run -itd --name hbase-regionserver --net=host myhbase:1.2.0 hbase regionserver -Dhbase.regionserver.port=16020 -Dhbase.regionserver.info.port=16030 -Dhbase.zookeeper.quorum=master.mesos:2181 -Dzookeeper.znode.parent=/myhbase -Dhbase.rootdir=hdfs://namenode.hdfs.marathon.mesos:9000/myhbase -Dhbase.cluster.distributed=true -Dhbase.server.ip.enabled=true start
```