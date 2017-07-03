# Jenkins

jenkins:2.32.3-alpine


## Dockerfile

> https://github.com/jenkinsci/docker/commit/4a6465124b05219b00cbf97ba8d2f4a7738e4cdc
> https://github.com/jenkinsci/docker/blob/4a6465124b05219b00cbf97ba8d2f4a7738e4cdc/Dockerfile


## Build

因为 mesos 节点默认使用的是 root 用户，而该 jenkins 镜像默认使用的是 `jenkins` 用户。如果使用 jenkins 用户会导致挂载是没有权限问题，尤其是当不知道 jenkins 容器分配到哪个节点时更为麻烦，所以统一使用 root 用户。

只修改了 Dockerfile
将jenkins 的使用用户改为root。因为mesos节点默认使用的是root用户，而如果jenkins容器如果使用jenkins用户会导致挂载是没有权限问题，尤其是当不知道jenkins容器分配到哪个节点时更为麻烦，所以统一使用root用户

```bash
cd docker
docker build -t jins/jenkins:2.32.3-alpine -f Dockerfile .
```

## Deployment

```bash
$ docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home jenkins:2.32.3-alpine
```