# ETCD

ETCD docker image with `etcd` and `etcdctl`.

## Download

```bash
$ export VERSION="v2.3.7"
$ curl -L -o etcdv2.tar.gz http://github.com/coreos/etcd/releases/download/${VERSION}/etcd-${VERSION}-linux-amd64.tar.gz
```

## Deployment

```bash
$ docker build -f Dockerfile -t etcd:2.3.7 .
```

## Deployment

`336163fc-3c31-11e7-9661-64006a75624e` 是我用 node.js 控制台随机生成的 UUID (token), 也可以自定义.　目前没有办法动态调整　IP, 但是在 marathon 可以直接指定域名从而不用关心具体的 IP.

`etcd` 命令行参数也可以通过环境变量来指定:

```
ETCD_INITIAL_CLUSTER="infra0=e1=http://172.20.0.101:2380,e2=http://172.20.0.102:2380,e3=http://172.20.0.103:2380"
ETCD_INITIAL_CLUSTER_STATE=new
```

```
--initial-cluster infra0=e1=http://172.20.0.101:2380,e2=http://172.20.0.102:2380,e3=http://172.20.0.103:2380 \
--initial-cluster-state new
```

创建私有网络

```bash
$ docker network create --driver bridge --subnet 172.20.0.1/24 mynet
```

- node1

```bash
$ docker run -it --name node1 --net mynet --ip 172.20.0.101 \
 -v etcd_data_1:/data -d etcd:2.3.7 \
 etcd --name e1 --data-dir /data \
 --advertise-client-urls http://172.20.0.101:2379 \
 --initial-advertise-peer-urls  http://172.20.0.101:2380 \
 --listen-peer-urls http://0.0.0.0:2380 \
 --listen-client-urls http://0.0.0.0:2379 \
 --initial-cluster e1=http://172.20.0.101:2380,e2=http://172.20.0.102:2380,e3=http://172.20.0.103:2380 \
 --initial-cluster-token 336163fc-3c31-11e7-9661-64006a75624e \
 --initial-cluster-state new
```

- node2

```bash
$ docker run -it --name node2 --net mynet --ip 172.20.0.102 \
 -v etcd_data_2:/data -d etcd:2.3.7 \
 etcd --name e2 --data-dir /data \
 --advertise-client-urls http://172.20.0.102:2379 \
 --initial-advertise-peer-urls  http://172.20.0.102:2380 \
 --listen-peer-urls http://0.0.0.0:2380 \
 --listen-client-urls http://0.0.0.0:2379 \
 --initial-cluster e1=http://172.20.0.101:2380,e2=http://172.20.0.102:2380,e3=http://172.20.0.103:2380 \
 --initial-cluster-token 336163fc-3c31-11e7-9661-64006a75624e \
 --initial-cluster-state new
```

- node3

```bash
$ docker run -it --name node3 --net mynet --ip 172.20.0.103 \
 -v etcd_data_3:/data -d etcd:2.3.7 \
 etcd --name e3 --data-dir /data \
 --advertise-client-urls http://172.20.0.103:2379 \
 --initial-advertise-peer-urls  http://172.20.0.103:2380 \
 --listen-peer-urls http://0.0.0.0:2380 \
 --listen-client-urls http://0.0.0.0:2379 \
 --initial-cluster e1=http://172.20.0.101:2380,e2=http://172.20.0.102:2380,e3=http://172.20.0.103:2380 \
 --initial-cluster-token 336163fc-3c31-11e7-9661-64006a75624e \
 --initial-cluster-state new
```


## Test and Check cluster health

```bash
$ docker exec -it node1 etcdctl cluster-health
```

```bash
$ docker exec -it node1 etcdctl --endpoints=http://127.0.0.1:2379 set foo "bar"
$ docker exec -it node1 etcdctl --endpoints=http://127.0.0.1:2379 get foo
```

## Add member

```bash
$ docker run -it --name node4 --net mynet --ip 172.20.0.104 \
 -v etcd_data_4:/data -d etcd:2.3.7 \
 etcd --name e4 --data-dir /data \
 --advertise-client-urls http://172.20.0.104:2379 \
 --initial-advertise-peer-urls  http://172.20.0.104:2380 \
 --listen-peer-urls http://0.0.0.0:2380 \
 --listen-client-urls http://0.0.0.0:2379 \
 --initial-cluster e1=http://172.20.0.101:2380,e2=http://172.20.0.102:2380,e3=http://172.20.0.103:2380,e4=http://172.20.0.104:2380 \
 --initial-cluster-token 336163fc-3c31-11e7-9661-64006a75624e \
 --initial-cluster-state existing
```

## 总结

如果使用 marathon 来同时部署 etcd 和 calico, 存在一个矛盾： etcd 需要依赖 calico 网络, calico 又需要依赖 etcd 存储，那该怎么办呢？

事实上，考虑到要快速解决故障，我直接在主机上部署了 calico，并不打算在 marathon 中部署 calico。另一方面，我尝试着部署 calico 没能成功，因为没法动态设置主机 IP。

因为 calico 部署在了主机上，而 calico 又依赖 etcd，所以 etcd 也随 zk 直接部署在了主机上。主机上部署 etcd 和 zk 是为了保障整个 mesos 集群（含 calico 网络）的高可用。

因此，为了避免主机上的 etcd 和 zk 集群受其他应用的影响导致 mesos 集群不可用，我又在 marathon 上部署了 etcd 和 zk 集群，供其他应用（如 kafka）使用。


## 参考文章

> https://coreos.com/etcd/docs/latest/v2/clustering.html