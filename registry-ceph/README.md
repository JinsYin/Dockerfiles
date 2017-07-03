# Registry on ceph

## 参考镜像

registry:2.6.1

```bash
$ git clone -b registry-v2.6.1 https://github.com/docker/distribution-library-image.git
```

> https://github.com/docker/distribution-library-image

为什么不基于官方镜像镜像重构？
```
因为新构建的镜像可以修改端口，同时也可以不使用外挂卷，而官方镜像同时指定了 `EXPOSE` 和 `VOLUME`，每次都会创建一个带有随机 volume id 的卷。
```

## 构建镜像

```bash
$ docker build -f Dockerfile -t registry-ceph:2.6.1 .
```

## 部署

using `local` storage

```bash
$ docker run -itd --name registry -p 5000:5000 -e HTTP_PORT=5000 -v registry-data:/var/lib/registry registry-ceph:2.6.1	
```

using `ceph radosgw` storage

```bash
$ docker run -itd --name registry -p 5000:5000 \
 -e HTTP_PORT=5000 \
 -e STORAGE_SWIFT_AUTHURL="http://192.168.111.204:7480/auth/v1" \
 -e STORAGE_SWIFT_USERNAME="registry:swift" \
 -e STORAGE_SWIFT_PASSWORD="NyINaRDvoFiZUAaCUHsNz6Nzu6glbn729rfDqh7r" \
 registry-ceph:2.6.1
```

## 设置密码（过）

```bash
$ docker run --entrypoint htpasswd registry:2.6.1 -Bbn yiwei yiweibigdata > /etc/docker/auth/htpasswd
```

## Login（过）

```
$ docker login registry.marathon.mesos:5000 # yiwei/yiweibigdata
```

## 获取镜像列表

```bash
$ curl http://registry.marathon.mesos:5000/v2/_catalog
```

## 获取 registry 镜像的 tag 列表

```bash
$ curl http://registry.marathon.mesos:5000/v2/nginx/tags/list
```

## 获取镜像的 Digest, 从 http response header 中获取

```bash
$ curl -s -D - http://registry.marathon.mesos:5000/v2/nginx/manifests/1.11.9-alpine -o /dev/null
```

## 删除镜像 (出错: MANIFEST_UNKNOWN)

```bash
$ curl http://registry.marathon.mesos:5000/v2/nginx/manifests/sha256:388....
```

## 无法删除镜像问题

> http://www.jianshu.com/p/4053f6e5d8bf

我的办法: 从 image 存储路径 /var/lib/registry/docker/registry/v2/repositories 中删除（只针对本地存储）。