# Alluxio

## Tarball

```bash
$ wget http://downloads.alluxio.org/downloads/files/1.4.0/alluxio-1.4.0-bin.tar.gz -O alluxio-1.4.0-bin.tar.gz
```

## Dockerfile

> https://github.com/Alluxio/alluxio/blob/branch-1.5/integration/docker

## Build

```bash
$ docker build -f Dockerfile -t alluxio:1.4.0 .
```

OR

```bash
$ docker build -t alluxio:1.4.0 --build-arg ALLUXIO_TARBALL=alluxio-1.4.0-bin.tar.gz .
```

## Deployment

master

```bash
$ docker run -itd --name alluxio-master --net=host \
 -v alluxio_master_underfs:/underStorage \
 -e ALLUXIO_MASTER_HOSTNAME=${INSTANCE_PUBLIC_IP} \
 -e ALLUXIO_UNDERFS_ADDRESS=/underStorage \
 alluxio:1.4.0 master
```

worker

```bash
$ docker run -itd --name alluxio-worker --net=host \
 -v alluxio_worker_underStorage:/underStorage \
 -e ALLUXIO_MASTER_HOSTNAME=${INSTANCE_PUBLIC_IP} \
 -e ALLUXIO_WORKER_MEMORY_SIZE=1GB \
 -e ALLUXIO_UNDERFS_ADDRESS=/underStorage \
 alluxio:1.4.0 worker
```

使用快速短路读取的方式启动　worker

```bash
$ sudo mkdir /mnt/ramdisk
$ sudo mount -t ramfs -o size=1G ramfs /mnt/ramdisk
$ sudo chmod a+w /mnt/ramdisk
```

```bash
$ docker run -itd --name alluxio-worker --net=host \
 -v /mnt/ramdisk:/mnt/ramdisk \
 -v alluxio_worker_underStorage:/underStorage \
 -e ALLUXIO_MASTER_HOSTNAME=${INSTANCE_PUBLIC_IP} \
 -e ALLUXIO_RAM_FOLDER=/mnt/ramdisk \
 -e ALLUXIO_WORKER_MEMORY_SIZE=1GB \
 -e ALLUXIO_UNDERFS_ADDRESS=/underStorage \
 alluxio:1.4.0 worker
```

## Alluxio on HDFS

master （相应的需要事先在 HDFS 中创建 /alluxio/data）

```bash
$ docker run -itd --name alluxio-master --net=host \
 -e ALLUXIO_MASTER_HOSTNAME=${INSTANCE_PUBLIC_IP} \
 -e ALLUXIO_UNDERFS_ADDRESS=hdfs://NAMENODE:PORT/alluxio/data \
 alluxio:1.4.0 master
```

worker

```bash
$ docker run -itd --name alluxio-worker --net=host \
 -e ALLUXIO_MASTER_HOSTNAME=${INSTANCE_PUBLIC_IP} \
 -e ALLUXIO_WORKER_MEMORY_SIZE=1GB \
 -e ALLUXIO_UNDERFS_ADDRESS=hdfs://namenode.hdfs.marathon.mesos:9000/alluxio/data \
 alluxio:1.4.0 worker
```

## Alluxio on ceph using s3

（没有测试成功）

master

```bash
$ docker run -itd --name alluxio-master --net=host \
 -e ALLUXIO_MASTER_HOSTNAME=${INSTANCE_PUBLIC_IP} \
 -e ALLUXIO_UNDERFS_ADDRESS=s3a://alluxio/underfs \
 -e AWS_ACCESSKEYID=IP8VE2US9VSQB9K63PH6 \
 -e AWS_SECRETKEY=8owBvCIP8tVH4oIE1KDAcvLyvIr0QCEyw6NcWdZa \
 -e ALLUXIO_UNDERFS_S3_ENDPOINT=http://192.168.111.204:7480 \
 -e ALLUXIO_UNDERFS_S3_DISABLE_DNS_BUCKETS=true \
 -e ALLUXIO_UNDERFS_S3A_INHERIT_ACL= \
 alluxio:1.4.0 master
```

worker

```
$ docker run -it --name alluxio-master --net=host \
 -e ALLUXIO_MASTER_HOSTNAME=192.168.111.100 \
 -e ALLUXIO_UNDERFS_ADDRESS=s3a://my-new-bucket/underfs \
 -e AWS_ACCESSKEYID=IP8VE2US9VSQB9K63PH6 \
 -e AWS_SECRETKEY=8owBvCIP8tVH4oIE1KDAcvLyvIr0QCEyw6NcWdZa \
 -e ALLUXIO_UNDERFS_S3_ENDPOINT=http://192.168.111.204:7480 \
 -e ALLUXIO_UNDERFS_S3_DISABLE_DNS_BUCKETS=true \
 alluxio:1.4.0 worker
```

## Alluxio on ceph using swift

创建用户

```bash
$ radosgw-admin user create --uid="alluxio" --display-name="Alluxio User"　＃　为 s3 接口创建用户
$ radosgw-admin subuser create --uid="alluxio" --subuser=alluxio:swift --access=full　＃　为 swift 创建子用户
$ radosgw-admin user info --uid="alluxio"
```

master

```bash
$ docker run -itd --name alluxio-master --net=host \
 -e ALLUXIO_MASTER_HOSTNAME=192.168.111.199 \
 -e ALLUXIO_UNDERFS_ADDRESS=swift://alluxiopool \
 -e ALLUXIO_JAVA_OPTS="-Dfs.swift.password=yXZ6bWITiyPa78i6aOals7ceomPbC5xLdO06tenO -Dfs.swift.tenant=alluxio -Dfs.swift.user=swift -Dfs.swift.auth.url=http://192.168.111.204:7480/auth/v1 -Dfs.swift.use.public.url=true -Dfs.swift.auth.method=swiftauth" \
 alluxio:1.4.0 master
```

worker

```bash
$ docker run -itd --name alluxio-worker --net=host \
 -e ALLUXIO_MASTER_HOSTNAME=192.168.111.199 \
 -e ALLUXIO_WORKER_MEMORY_SIZE=1GB \
 -e ALLUXIO_UNDERFS_ADDRESS=swift://alluxiopool \
 -e ALLUXIO_JAVA_OPTS="-Dfs.swift.password=yXZ6bWITiyPa78i6aOals7ceomPbC5xLdO06tenO -Dfs.swift.tenant=alluxio -Dfs.swift.user=swift -Dfs.swift.auth.url=http://192.168.111.204:7480/auth/v1 -Dfs.swift.use.public.url=true -Dfs.swift.auth.method=swiftauth" \
 alluxio:1.4.0 worker
```

## HA cluster

（相应的需要事先在 HDFS 中创建 /alluxio/journal。另外，alluxio 使用的是主机名注册到 zookeeper，所以需要确保使用主机名可以无密钥互访）

master （应该启多个）

```bash
$ docker run -itd --name alluxio-master --net=host \
 -e ALLUXIO_JAVA_OPTS="-Dalluxio.zookeeper.enabled=true -Dalluxio.zookeeper.address=master.mesos:2181 -Dalluxio.master.journal.folder=hdfs://namenode.hdfs.marathon.mesos:9000/alluxio/journal -Dalluxio.zookeeper.election.path=/alluxio/election -Dalluxio.zookeeper.leader.path=/alluxio/leader" \
 alluxio:1.4.0 master
```

docker run -itd --name alluxio-master2 --net=host \
 -e ALLUXIO_JAVA_OPTS="-Dalluxio.zookeeper.enabled=true -Dalluxio.zookeeper.address=master.mesos:2181 -Dalluxio.master.journal.folder=hdfs://namenode.hdfs.marathon.mesos:9000/alluxio/journal -Dalluxio.zookeeper.election.path=/alluxio/election -Dalluxio.zookeeper.leader.path=/alluxio/leader" \
 alluxio:1.4.0 master

worker 

```bash
$ docker run -itd --name alluxio-worker --net=host \
 -e ALLUXIO_JAVA_OPTS="-Dalluxio.zookeeper.enabled=true -Dalluxio.zookeeper.address=master.mesos:2181 -Dalluxio.master.journal.folder=hdfs://namenode.hdfs.marathon.mesos:9000/alluxio/journal -Dalluxio.zookeeper.election.path=/alluxio/election -Dalluxio.zookeeper.leader.path=/alluxio/leader" \
 alluxio:1.4.0 worker
```

## Test

```bash
$ docker exec -it alluxio-worker /bin/sh
$ cd opt/alluxio 
$ bin/alluxio runTests # 试试两次
``

## Configuration

> http://www.alluxio.org/docs/1.4/cn/Configuration-Settings.html

## 参考

> http://www.alluxio.org/docs/master/cn/Running-Alluxio-On-Docker.html