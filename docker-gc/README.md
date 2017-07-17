# Docker-gc

docker-gc 负责回收退出(exited)超过一小时的容器和镜像.

## Dockerfile

> https://github.com/spotify/docker-gc/blob/master/Dockerfile

## Document

> https://github.com/spotify/docker-gc

## Deployment

```bash
$ FORCE_IMAGE_REMOVAL=1 docker-gc
```

```bash
$ MINIMUM_IMAGES_TO_SAVE=10 docker-gc
```

如果移除容器报错而又想移除掉,可以使用 `FORCE_CONTAINER_REMOVAL=1` 阿里强制移除
```bash
$ FORCE_CONTAINER_REMOVAL=1 docker-gc
```

默认情况下,如果容器退出没有超过 1h (3600s) 是不会被移除的, 但可以通过 `GRACE_PERIOD_SECONDS` 来修改默认移除的时间.
```bash
$ GRACE_PERIOD_SECONDS=86400 docker-gc # 单位: s
```

如果设置以上的选项,需要设置 `DRY_RUN=1` 来覆写默认值
```bash
$ DRY_RUN=1 docker-gc
```

```bash
$ docker run -it --name docker-gc --rm -v /etc:/etc:ro \
-v /var/run/docker.sock:/var/run/docker.sock \
-v dockergc_data:/var/lib/docker-gc \
-e GRACE_PERIOD_SECONDS=60 \
-e DRY_RUN=1 spotify/docker-gc:latest
```
