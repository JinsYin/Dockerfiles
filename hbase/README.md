# HBase

Ĭ�������HBase ʹ�� `hostname` ��ע����� zookeeper ���ڷ����֣�������ʹ�á�ip ��ַ��������Ҫ������֮���������Կ���ʡ����� docker ������ԣ�����ͨ�� dns ʹ����������������������ʹ�� mesos ����ʱ��Ȼ������һЩ��ֵĳ�������ÿ����һ�� regionserver �ͻ�Ī�������Զ�����һ��ʹ�� mesos id �����Ĳ����� regionserver��

�� `2.0.0` ��ʼ���п������ṩ��һ�� patch��Ϊ hbase ������һ������ `hbase.regionserver.use.ip` ������ʹ�� ip��ע�����[����](https://issues.apache.org/jira/browse/HBASE-11768)

Ŀǰ������ʹ�õİ汾�� `1.2.0`������֧��ʹ�� ip ע������������� hbase 1.2.0 Դ��Ļ������������������ԣ� `hbase.zookeeper.ip.enabled` �� `hbase.zookeeper.ip.address`��

`hbase.server.ip.enabled` ���� master �� regionserver ʹ�� ip ��ע����� zookeeper��Ĭ��ֵ�� `false`������� ip ���Զ���ȡ�ġ�
`hbase.server.ip.address` ����ָ�� ip ��ַ������ڶ����������Ƿǳ��а����ġ�Ҫʹ�����������Ҫ�� `hbase.server.ip.enabled` ��Ϊ `true`��

����ο�[����](./.myhbase/READMD.md)

## Build

```bash
$ docker build -f Dcokerfile -t hbase:1.2.0 .
```

OR

```bash
$ docker build -t hbase:1.2.0 --build-arg HBASE_TARBALL=hbase-1.2.0-bin.tar.gz .
```

## Deployment

��ȷ�� master �� master-backup �ڲ�ͬ�Ļ����ϣ�

- master

```bash
$ docker run -itd --name hbase-master --net=host hbase:1.2.0 hbase master -Dhbase.master.port=16000 -Dhbase.master.info.port=16010 -Dhbase.zookeeper.quorum=master.mesos:2181 -Dzookeeper.znode.parent=/hbase -Dhbase.rootdir=hdfs://namenode.hdfs.marathon.mesos:9000/hbase -Dhbase.cluster.distributed=true start
```

- master-backup

```bash
$ docker run -itd --name hbase-backup --net=host hbase:1.2.0 hbase master  -Dhbase.master.port=16000 -Dhbase.master.info.port=16010 -Dhbase.zookeeper.quorum=master.mesos:2181 -Dzookeeper.znode.parent=/hbase -Dhbase.rootdir=hdfs://namenode.hdfs.marathon.mesos:9000/hbase -Dhbase.cluster.distributed=true --backup start
```

- regionserver

```bash
$ docker run -itd --name hbase-regionserver --net=host hbase:1.2.0 hbase regionserver -Dhbase.regionserver.port=16020 -Dhbase.regionserver.info.port=16030 -Dhbase.zookeeper.quorum=master.mesos:2181 -Dzookeeper.znode.parent=/hbase -Dhbase.rootdir=hdfs://namenode.hdfs.marathon.mesos:9000/hbase -Dhbase.cluster.distributed=true start
```