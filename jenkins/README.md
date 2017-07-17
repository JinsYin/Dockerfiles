# Jenkins

jenkins:2.32.3-alpine

因为 mesos 节点默认使用的是 root 用户，而该 jenkins 镜像默认使用的是 `jenkins` 用户。如果使用 jenkins 用户会导致挂载是没有权限问题。
Dockerfile 默认是 root 用户，在运行的时候可以使用 `--user` 参数来覆盖 `USER` 指令。


## Dockerfile

> https://github.com/jenkinsci/docker/commit/4a6465124b05219b00cbf97ba8d2f4a7738e4cdc
> https://github.com/jenkinsci/docker/blob/4a6465124b05219b00cbf97ba8d2f4a7738e4cdc/Dockerfile


## Deployment

```bash
$ docker run -it --name myjenkins --user root -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -d jenkins:2.32.3-alpine
```

获取密码：

```bash
$ docker exec -it myjenkins cat /var/jenkins_home/secrets/initialAdminPassword
```


## Jenkins on mesos

mesosphere/jenkins:3.0.3-2.32.3

> https://github.com/mesosphere/dcos-jenkins-service/blob/3.0.3-2.32.3/Dockerfile


## Jenkins Docker-in-Docker Agent

mesosphere/jenkins-dind:0.5.0-alpine

> https://github.com/mesosphere/dcos-jenkins-dind-agent