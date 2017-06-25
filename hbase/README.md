# HBase

默认情况，HBase 使用 `hostname` 来注册服务到 zookeeper 用于服务发现，而不是使用　ip 地址，所以需要主机名之间可以无密钥访问。对于 docker 部署而言，可以通过 dns 使用域名代替主机名，不过使用 mesos 部署时依然出现了一些奇怪的出错，比如每部署一个 regionserver 就会莫名其妙自动创建一个使用 mesos id 命名的不可用 regionserver。

从 `2.0.0` 开始，有开发者提供了一个 patch，为 hbase 增加了一个属性 `hbase.regionserver.use.ip` 来允许使用 ip　注册服务，[详情](https://issues.apache.org/jira/browse/HBASE-11768)

目前，我们使用的版本是 `1.2.0`，还不支持使用 ip 注册服务，所以我在 hbase 1.2.0 源码的基础上增加了两个属性： `hbase.zookeeper.ip.enabled` 和 `hbase.zookeeper.ip.address`。

`hbase.server.ip.enabled` 允许 master 和 regionserver 使用 ip 来注册服务到 zookeeper，默认值是 `false`，这里的 ip 是自动获取的。
`hbase.server.ip.address` 允许指定 ip 地址，这对于多网卡而言是非常有帮助的。要使用这个属性需要将 `hbase.server.ip.enabled` 置为 `true`。

详情参考[这里](./.myhbase/READMD.md)

## Build

```bash
$ docker build -f Dcokerfile -t hbase:1.2.0 .
```

OR

```bash
$ docker build -t hbase:1.2.0 --build-arg HBASE_TARBALL=hbase-1.2.0-bin.tar.gz .
```

## Deployment

（确保 master 和 master-backup 在不同的机器上）

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