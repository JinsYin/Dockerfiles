# HDFS docker image

## Build

```bash
$ docker build -f Dockerfile -t hdfs:2.7.3 .
```

## Compose

```bash
$ docker-compose -f docker-compose.yml up -d
```

## HDFS cluster

启动 NameNode,你可以使用 `-e NAMENODE_FORMAT_FORCED=true` 来强制格式化 NameNode.如果想挂载 NameNode 的数据到 docker 卷或主机,除了使用 `-v` 来挂载外,还需要指定 `-D dfs.namenode.name.dir`,否则 `/data/hdfs/dfs/name` 不会自动创建.
```bash
$ docker run -it --name namenode -p 9000:9000 -p 50070:50070 \
-e HADOOP_TMP_DIR=/data/hdfs hdfs:2.7.3 \
-v namenode_data:/data/hdfs/dfs/name hdfs namenode \
-D dfs.namenode.name.dir=/data/hdfs/dfs/name \
-D fs.defaultFS=hdfs://0.0.0.0:9000 \
-D dfs.replication=3 \
-D dfs.namenode.datanode.registration.ip-hostname-check=false \
-D dfs.permissions.enabled=false \
```

启动 DataNode
```bash
$ docker run -it --name datanode -d -p 50010:50010 -p 50020:50020 \
-e HADOOP_TMP_DIR=/data/hdfs -v datanode_data:/data/hdfs/dfs/data hdfs:2.7.3 hdfs datanode \
-fs hdfs://xxx.xxx.xxx.xxx:9000 \
-D dfs.datanode.data.dir=/data/hdfs/dfs/data \
-D dfs.permissions.enabled=false
```

## High Availability

启动 NameNode
```bash
$ docker run -it --name nn1 -d -p 9000:9000 -p 50070:50070 \
--add-host=zk1:192.168.111.203 \
--add-host=zk2:192.168.111.204 \
--add-host=zk3:192.168.111.205 \
--link nn1:nn1 \
--link nn2:nn2 \
--link jn1:jn1 \
--link jn2:jn2 \
--link jn3:jn3 \
-e HADOOP_TMP_DIR=/data/hdfs hdfs:2.7.3 hdfs namenode \
-D fs.defaultFS=hdfs://ha_hdfs \
-D ha.zookeeper.quorum=zk1:2181,zk2:2181,zk3:2181 \
-D dfs.nameservices=ha_hdfs \
-D dfs.ha.namenodes.ha_hdfs=nn1,nn2 \
-D dfs.namenode.rpc-address.ha_hdfs.nn1=nn1:8020 \
-D dfs.namenode.rpc-address.ha_hdfs.nn2=nn2:8020 \
-D dfs.namenode.http-address.ha_hdfs.nn1=nn1:50070 \
-D dfs.namenode.http-address.ha_hdfs.nn2=nn2:50070 \
-D dfs.namenode.shared.edits.dir=qjournal://jn1:8485;jn2:8485;jn3:8485/ha_hdfs -D dfs.client.failover.proxy.provider.ha_hdfs=org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider \
-D dfs.ha.automatic-failover.enabled=true \
-D dfs.journalnode.edits.dir=/data/hdfs/dfs/journal
```

启动 StandbyNameNode
```bash
$ 
```

启动 JournalNode
```bash
$ 
```

启动 DataNode
```bash
$ 
```
