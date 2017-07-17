# Docker in Docker

docker:1.13.1-dind


## Dockerfile

> https://github.com/docker-library/docker/blob/50ec917e1b7601d655daee8893567e8cfd213248/1.13/Dockerfile


## Deployment

```bash
// --privileged
$ docker run -it --name docker --privileged -d docker:1.13.1-dind
```