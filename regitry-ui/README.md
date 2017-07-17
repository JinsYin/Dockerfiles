# Regitry UI

docker 官方并没有为 docker registry 提供 UI 及管理, 以下是我找到的几个不错的开源项目:

- [konradkleine/docker-registry-frontend](https://hub.docker.com/r/konradkleine/docker-registry-frontend/)
- [hyper/docker-registry-web](https://hub.docker.com/r/hyper/docker-registry-web/)
- [opensuse/portus](https://hub.docker.com/r/opensuse/portus/)
- [gitlab/gitlab-ce](https://hub.docker.com/r/gitlab/gitlab-ce/)

GitLab 8.8 开始集成了 Docker Registry 功能 (GitLab Container Registry), 它可以与 GitLab CI 协同工作. 

出于长久支持和企业维护的角度考虑,我觉得 `Portus` 和 `GitLab` 都是不错的选择，但是为了降低耦合度，我最终选择 opensuse/portus。

## Dockerfile

> https://github.com/openSUSE/docker-containers/blob/master/derived_images/portus/Dockerfile

## Deployment

```bash
$ docker run -it --name portus -p 3000:3000 \
 -e PORTUS_SECRET_KEY_BASE=ff0b4a7114fc8f8b9ad6237f5fb8a15819e6e26d4ec86958abdb79348efc0e6c1803f850cfed66dc0e4b5626695ee18329de81567938e92276077252c51eef18 \
 -e PORTUS_CHECK_SSL_USAGE_ENABLED=false \
 -e PORTUS_PASSWORD=portus123456 \
 -e PORTUS_PRODUCTION_HOST=mysql.mysql.marathon.mesos \
 -e PORTUS_PRODUCTION_USERNAME=root \
 -e PORTUS_PRODUCTION_PASSWORD=root123456 \
 -e PORTUS_PRODUCTION_DATABASE=portus \
 -e PORTUS_MACHINE_FQDN_VALUE=localhost \
 -e PORTUS_PUMA_WORKERS=1 \
 -e PORTUS_PUMA_MAX_THREADS=1 \
 -e RAILS_SERVE_STATIC_FILES=false \
 -d opensuse/portus:2.2
```

## Document

> http://port.us.org/documentation.html
> https://github.com/SUSE/Portus
> https://github.com/openSUSE/docker-containers
> https://docs.gitlab.com/omnibus/docker/

## 参考文章

> http://www.aibang.com/news/ctt-detail-id68179
> https://about.gitlab.com/2016/05/23/gitlab-container-registry/
> http://docs.gitlab.com/ce/user/project/container_registry.html
> http://docs.gitlab.com/ce/administration/container_registry.html


