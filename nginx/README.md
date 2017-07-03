# Nginx

nginx:1.11.9-alpine

## Dockerfile

https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine/Dockerfile

## Deployment

```bash
$ docker run --name nginx-web -p 8000:80-d nginx:1.11.9-alpine
```