# Portainer

image name: portainer/portainer
tag: 1.13.0

# Document

- https://portainer.readthedocs.io/en/latest/deployment.html

# Deployment

无 endpoint
```bash
$ docker run -d -p 9000:9000 -v portainer_data:/data portainer/portainer:1.13.0
```

默认连接本机 docker engine
```bash
$ docker run -d -p 9000:9000 --privileged -v portainer_data:/data \
-v /var/run/docker.sock:/var/run/docker.sock portainer/portainer:1.13.0
```

使用 SSL
```bash
```

添加管理员密码
```bash
$ htpasswd -nbB admin 123456 | cut -d ":" -f 2 # 生成加密的密码
$ docker run -d -p 9000:9000 portainer/portainer:1.13.0 --admin-password '$2y$05$R/rXRR7GzTTjS3GLvHwW7udCVtLj.g1mL9R9KbzgQ5ogiHRRgT7aa'
```
