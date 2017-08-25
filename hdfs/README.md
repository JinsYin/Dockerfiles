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

�״����� NameNode ʱ����� `dfs.namenode.name.dir` ��Ӧ�Ĺ���Ŀ¼Ϊ�ջ��Զ���ʽ�� NameNode���������û�з��ֱ仯��֮�󲻻��ٸ�ʽ�� NameNode�������Ҫǿ�Ƹ�ʽ������������ `-e NAMENODE_FORMAT_FORCED=true`��

`dfs.namenode.name.dir` Ĭ��·�� `/tmp/hadoop-root/dfs/name`��

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

��������(���²�����������)��

1). �������� JournalNode
```bash
$ hdfs journalnode
```

2). ���� nn1�� nn2

2.1)nn1
```bash
$ hdfs namenode -format # �¼�Ⱥ��Ҫ��ʽ��
```

��ʼ�� JournalNode
```bash
# ������һ̨ NameNode �ڵ��ʼ�� JournalNode���������� JNs ��ʼ�� `dfs.namenode.shared.edits.dir` ��Ӧ��Ϣ
$ hdfs namenode -initializeSharedEdits [-force | -nonInteractive] 
```

����һ�� NameNode ��ʼ�� zk ���ã� ����ѡ���� nn1 ��
```bash
$ hdfs zkfc -format
```

```bash
$ hdfs namenode # ���� nn1
```

2.2) nn2
```bash
# ע�⣺����� nn2 �� NameNode �ѱ� format �����ǽ��� HA HDFS �ļ�Ⱥת����Ϊ HA HDFS ����Ҫִ��������衣
$ hdfs namenode -bootstrapStandby -force # �� nn2 ͬ�� nn1 �����µ� FSimage
```

```bash
$ hdfs namenode # ���� nn2
```

nn1�� nn2 ����֮����Ȼ�������� Standby ״̬�� ͬʱ��־��ʾ���� `Operation category JOURNAL is not supported in state standby`.���ң���Ϊû�� Active NameNode�� DataNode Ҳ�޷�����.

3). �������е� DataNode
```bash
$ hdfs datanode
```

4). �ֶ��л� Active NameNode
```bash
$ hdfs haadmin -transitionToActive nn1 # ���� nn1 ��״̬Ϊ Active
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
-D ha.zookeeper.quorum=zk1:2181��zk2:2181��zk3:2181 \
-D dfs.nameservices=ha_hdfs \
-D dfs.ha.namenodes.ha_hdfs=nn1��nn2 \
-D dfs.namenode.rpc-address.ha_hdfs.nn1=nn1:8020 \
-D dfs.namenode.rpc-address.ha_hdfs.nn2=nn2:8020 \
-D dfs.namenode.http-address.ha_hdfs.nn1=nn1:50070 \
-D dfs.namenode.http-address.ha_hdfs.nn2=nn2:50070 \
-D dfs.namenode.shared.edits.dir=qjournal://jn1:8485;jn2:8485;jn3:8485/ha_hdfs -D dfs.client.failover.proxy.provider.ha_hdfs=org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider \
-D dfs.ha.automatic-failover.enabled=true \
-D dfs.journalnode.edits.dir=/data/hdfs/dfs/journal
```

���� NameNode������Ϊ nn1��nn2 ָ���̶��� IP��������� `--dns` ��ָ������.
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
-D ha.zookeeper.quorum=zk1:2181��zk2:2181��zk3:2181 \
-D dfs.nameservices=ha_hdfs \
-D dfs.ha.namenodes.ha_hdfs=nn1��nn2 \
-D dfs.namenode.rpc-address.ha_hdfs.nn1=nn1:8020 \
-D dfs.namenode.rpc-address.ha_hdfs.nn2=nn2:8020 \
-D dfs.namenode.http-address.ha_hdfs.nn1=nn1:50070 \
-D dfs.namenode.http-address.ha_hdfs.nn2=nn2:50070 \
-D dfs.namenode.shared.edits.dir=qjournal://jn1:8485;jn2:8485;jn3:8485/ha_hdfs -D dfs.client.failover.proxy.provider.ha_hdfs=org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider \
-D dfs.ha.automatic-failover.enabled=true
```

���� StandbyNameNode
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
-D ha.zookeeper.quorum=zk1:2181��zk2:2181��zk3:2181 \
-D dfs.nameservices=ha_hdfs \
-D dfs.ha.namenodes.ha_hdfs=nn1��nn2 \
-D dfs.namenode.rpc-address.ha_hdfs.nn1=nn1:8020 \
-D dfs.namenode.rpc-address.ha_hdfs.nn2=nn2:8020 \
-D dfs.namenode.http-address.ha_hdfs.nn1=nn1:50070 \
-D dfs.namenode.http-address.ha_hdfs.nn2=nn2:50070 \
-D dfs.namenode.shared.edits.dir=qjournal://jn1:8485;jn2:8485;jn3:8485/ha_hdfs -D dfs.client.failover.proxy.provider.ha_hdfs=org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider \
-D dfs.ha.automatic-failover.enabled=true
```

���� JournalNode
```bash
$ docker run -it --name jn1 -d -p 8485:8485 -p 8480:8480 \
dockerce/hdfs:2.7.3 hdfs journalnode -D dfs.journalnode.edits.dir=/data/hdfs/dfs/journal
```

���� DataNode
```bash
$ docker run -it --name datanode -d -p 50010:50010 -p 50020:50020 \
-e HADOOP_TMP_DIR=/data/hdfs \
-v datanode_data:/data/hdfs/dfs/data dockerce/hdfs:2.7.3 hdfs datanode \
-D fs.defaultFS=hdfs://ha_hdfs
-D dfs.datanode.data.dir=/data/hdfs/dfs/data \
-D dfs.permissions.enabled=false
```


## ע��

docker-entrypoint.sh ʹ�õ��� `#!/bin/bash`�� ���ʹ�� `#!/bin/sh` �����

## �ο�

> https://hub.docker.com/r/elek/hadoop-hdfs-namenode/