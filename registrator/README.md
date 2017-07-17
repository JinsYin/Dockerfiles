# gliderlabs/registrator

通常情况下，为了作服务注册和共享配置,需要在 dockerd 中配置 --cluster-store etcd://xxx.xxx.xxx.xxx:2379（比如 calico），而且每次修改配置之后都需要重启 docker，这在生产环境几乎不可想象的。

Registrator 是一个自动服务注册/注销工具，支持 Consul, etcd 和 SkyDNS 2。


## Dockerfile

> https://github.com/gliderlabs/registrator/blob/master/Dockerfile


## Deployment

* etcd

```bash
$ docker run -d --name registrator-etcd --net=host \
-v /var/run/docker.sock:/tmp/docker.sock \
gliderlabs/registrator:v7 etcd://master.mesos:2379
```

* consul

```bash
$ docker run -d --name registrator-consul --net=host \
-v /var/run/docker.sock:/tmp/docker.sock \
gliderlabs/registrator:v7 consul://localhost:8500
```
