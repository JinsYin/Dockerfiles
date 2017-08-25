# HDFS HA docker image

HDFS HA docker image without any configuration files.

## Build

```bash
$ docker build -f Dockerfile -t dockerce/hdfs:2.7.3 .
```

OR 

```bash
$ docker build -f Dockerfile -t dockerce/hdfs:2.7.3 --build-arg HADOOP_TARBALL=hadoop-2.7.3.tar.gz .
```

## Compose

```bash
$ docker-compose -f docker-compose.yml up -d
```

## HDFS cluster with SPOF

首次启动 NameNode 时，如果 `dfs.namenode.name.dir` 对应的挂载目录为空会自动格式化 NameNode。如果配置没有发现变化，之后不会再格式化 NameNode。如果想要强制格式化，可以设置 `-e NAMENODE_FORMAT_FORCED=true`。

`dfs.namenode.name.dir` 默认路径 `/tmp/hadoop-root/dfs/name`。

- NameNode

```bash
$ docker run -itd --name namenode -p 9000:9000 -p 50070:50070 \
-v hdfs-namenode:/hdfs/dfs/name dockerce/hdfs:2.7.3 hdfs namenode \
-Dfs.defaultFS=hdfs://0.0.0.0:9000 \
-Ddfs.namenode.name.dir=/hdfs/dfs/name \
-Ddfs.replication=3 \
-Ddfs.namenode.datanode.registration.ip-hostname-check=false \
-Ddfs.permissions.enabled=false
```

- DataNode

```bash
$ # local
$ docker run -itd --name datanode -p 50010:50010 -p 50020:50020 \
-v hdfs-datanode:/hdfs/dfs/data --link namenode:hdfs dockerce/hdfs:2.7.3 hdfs datanode \
-fs hdfs://namenode:9000 \
-Ddfs.datanode.data.dir=/hdfs/dfs/data \
-Ddfs.permissions.enabled=false
```

OR

```bash
$ # remote
$ docker run -itd --name datanode -p 50010:50010 -p 50020:50020 \
-v hdfs-datanode:/hdfs/dfs/data dockerce/hdfs:2.7.3 hdfs datanode \
-fs hdfs://[NAMENODE-IP]:9000 \
-Ddfs.datanode.data.dir=/hdfs/dfs/data \
-Ddfs.permissions.enabled=false
```

- Compose

```bash
$ docker-compose -f docker-compose.yml up
```

## HDFS cluster with high availability

启动步骤(以下操作忽略配置)：

1). 启动所有 JournalNode
```bash
$ hdfs journalnode
```

2). 启动 nn1， nn2

2.1)nn1
```bash
$ hdfs namenode -format # 新集群需要格式化
```

初始化 JournalNode
```bash
# 在任意一台 NameNode 节点初始化 JournalNode，会在所有 JNs 初始化 `dfs.namenode.shared.edits.dir` 相应信息
$ hdfs namenode -initializeSharedEdits [-force | -nonInteractive] 
```

任意一个 NameNode 初始化 zk 配置， 这里选择在 nn1 上
```bash
$ hdfs zkfc -format
```

```bash
$ hdfs namenode # 启动 nn1
```

2.2) nn2
```bash
# 注意：如果是 nn2 的 NameNode 已被 format 或者是将非 HA HDFS 的集群转化成为 HA HDFS 则不需要执行这个步骤。
$ hdfs namenode -bootstrapStandby -force # 让 nn2 同步 nn1 上最新的 FSimage
```

```bash
$ hdfs namenode # 启动 nn2
```

nn1， nn2 启动之后依然两个都是 Standby 状态， 同时日志提示出错 `Operation category JOURNAL is not supported in state standby`.而且，因为没有 Active NameNode， DataNode 也无法启动.

3). 启动所有的 DataNode
```bash
$ hdfs datanode
```

4). 手动切换 Active NameNode
```bash
$ hdfs haadmin -transitionToActive nn1 # 设置 nn1 的状态为 Active
```


```bash
$ docker run -it --name nn1 -d -p 9000:9000 -p 50070:50070 \
--ip=172.17.0.101 \
--add-host=jn1:192.168.100 \
--add-host=jn1:192.168.199 \
--add-host=jn1:192.168.207 \
--add-host=nn1:172.17.0.101 \
--add-host=nn2:172.17.0.102 \
--add-host=zk1:192.168.111.203 \
--add-host=zk2:192.168.111.204 \
--add-host=zk3:192.168.111.205 \
-e HADOOP_TMP_DIR=/data/hdfs dockerce/hdfs:2.7.3 hdfs namenode \
-D fs.defaultFS=hdfs://ha_hdfs \
-D ha.zookeeper.quorum=zk1:2181，zk2:2181，zk3:2181 \
-D dfs.nameservices=ha_hdfs \
-D dfs.ha.namenodes.ha_hdfs=nn1，nn2 \
-D dfs.namenode.rpc-address.ha_hdfs.nn1=nn1:8020 \
-D dfs.namenode.rpc-address.ha_hdfs.nn2=nn2:8020 \
-D dfs.namenode.http-address.ha_hdfs.nn1=nn1:50070 \
-D dfs.namenode.http-address.ha_hdfs.nn2=nn2:50070 \
-D dfs.namenode.shared.edits.dir=qjournal://jn1:8485;jn2:8485;jn3:8485/ha_hdfs -D dfs.client.failover.proxy.provider.ha_hdfs=org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider \
-D dfs.ha.automatic-failover.enabled=true \
-D dfs.journalnode.edits.dir=/data/hdfs/dfs/journal
```

启动 NameNode，必须为 nn1，nn2 指定固定的 IP，或者添加 `--dns` 并指定域名.
```bash
$ docker run -it --name nn1 -d -p 9000:9000 -p 50070:50070 \
--ip=172.17.0.101 \
--add-host=jn1:192.168.100 \
--add-host=jn1:192.168.199 \
--add-host=jn1:192.168.207 \
--add-host=nn1:172.17.0.101 \
--add-host=nn2:172.17.0.102 \
--add-host=zk1:192.168.111.203 \
--add-host=zk2:192.168.111.204 \
--add-host=zk3:192.168.111.205 \
-e HADOOP_TMP_DIR=/data/hdfs dockerce/hdfs:2.7.3 hdfs namenode \
-D fs.defaultFS=hdfs://ha_hdfs \
-D ha.zookeeper.quorum=zk1:2181，zk2:2181，zk3:2181 \
-D dfs.nameservices=ha_hdfs \
-D dfs.ha.namenodes.ha_hdfs=nn1，nn2 \
-D dfs.namenode.rpc-address.ha_hdfs.nn1=nn1:8020 \
-D dfs.namenode.rpc-address.ha_hdfs.nn2=nn2:8020 \
-D dfs.namenode.http-address.ha_hdfs.nn1=nn1:50070 \
-D dfs.namenode.http-address.ha_hdfs.nn2=nn2:50070 \
-D dfs.namenode.shared.edits.dir=qjournal://jn1:8485;jn2:8485;jn3:8485/ha_hdfs -D dfs.client.failover.proxy.provider.ha_hdfs=org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider \
-D dfs.ha.automatic-failover.enabled=true
```

启动 StandbyNameNode
```bash
$ docker run -it --name nn2 -d -p 9000:9000 -p 50070:50070 \
--ip=172.17.0.102 \
--add-host=jn1:192.168.100 \
--add-host=jn1:192.168.199 \
--add-host=jn1:192.168.207 \
--add-host=nn1:172.17.0.101 \
--add-host=nn2:172.17.0.102 \
--add-host=zk1:192.168.111.203 \
--add-host=zk2:192.168.111.204 \
--add-host=zk3:192.168.111.205 \
-e HADOOP_TMP_DIR=/data/hdfs dockerce/hdfs:2.7.3 hdfs namenode -bootstrapStandby \
-D fs.defaultFS=hdfs://ha_hdfs \
-D ha.zookeeper.quorum=zk1:2181，zk2:2181，zk3:2181 \
-D dfs.nameservices=ha_hdfs \
-D dfs.ha.namenodes.ha_hdfs=nn1，nn2 \
-D dfs.namenode.rpc-address.ha_hdfs.nn1=nn1:8020 \
-D dfs.namenode.rpc-address.ha_hdfs.nn2=nn2:8020 \
-D dfs.namenode.http-address.ha_hdfs.nn1=nn1:50070 \
-D dfs.namenode.http-address.ha_hdfs.nn2=nn2:50070 \
-D dfs.namenode.shared.edits.dir=qjournal://jn1:8485;jn2:8485;jn3:8485/ha_hdfs -D dfs.client.failover.proxy.provider.ha_hdfs=org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider \
-D dfs.ha.automatic-failover.enabled=true
```

启动 JournalNode
```bash
$ docker run -it --name jn1 -d -p 8485:8485 -p 8480:8480 \
dockerce/hdfs:2.7.3 hdfs journalnode -D dfs.journalnode.edits.dir=/data/hdfs/dfs/journal
```

启动 DataNode
```bash
$ docker run -it --name datanode -d -p 50010:50010 -p 50020:50020 \
-e HADOOP_TMP_DIR=/data/hdfs \
-v datanode_data:/data/hdfs/dfs/data dockerce/hdfs:2.7.3 hdfs datanode \
-D fs.defaultFS=hdfs://ha_hdfs
-D dfs.datanode.data.dir=/data/hdfs/dfs/data \
-D dfs.permissions.enabled=false
```


## 注意

docker-entrypoint.sh 使用的是 `#!/bin/bash`， 如果使用 `#!/bin/sh` 会出错。

## 参考

> https://hub.docker.com/r/elek/hadoop-hdfs-namenode/