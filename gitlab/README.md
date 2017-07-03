# GitLab

## GitLab-CE

## Dockerfile
https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/docker/Dockerfile

## Document

> https://gitlab.com/gitlab-org
> https://docs.gitlab.com/omnibus/docker/

## Deployment

为了避免配置文件不能跨主机的问题,需要通过环境变量来设置各项配置. 同时添加了义为的邮箱,方便提醒.

```bash
$ docker run -itd --name gitlab --restart=always \
-p 8000:8000 -p 2222:22 --hostname gitlab.example.com \
-e GITLAB_OMNIBUS_CONFIG="external_url 'http://192.168.111.199:8000/'; gitlab_rails['gitlab_shell_ssh_port'] = 2222; gitlab_rails['smtp_enable'] = true; gitlab_rails['smtp_address'] = 'smtp.exmail.qq.com'; gitlab_rails['smtp_port'] = 25; gitlab_rails['smtp_user_name'] = 'logs@eway.link'; gitlab_rails['smtp_password'] = 'Ab123456'; gitlab_rails['smtp_domain'] = 'smtp.qq.com'; gitlab_rails['smtp_authentication'] = 'plain'; gitlab_rails['smtp_enable_starttls_auto'] = false; user['git_user_email'] = 'logs@eway.link';" \
-v gitlab_config:/etc/gitlab \
-v gitlab_log:/var/log/gitlab \
-v gitlab_data:/var/opt/gitlab \
gitlab/gitlab-ce:8.14.10-ce.0
```

> 注: 需要确保 `-p 8000:8000` 和 `external_url 'http://xxx.xxx.xxx.xxx:8000/'` 这三处的端口是一致的.

## Environment variables

> https://docs.gitlab.com/ce/administration/environment_variables.html

## Email

> https://docs.gitlab.com/omnibus/settings/smtp.html

## Prometheus

> https://docs.gitlab.com/ce/administration/monitoring/prometheus/index.html

## Redis settings

```bash
$ cat /etc/gitlab/gitlab.rb
redis['enable'] = false

# Redis via TCP
gitlab_rails['redis_host'] = 'redis.example.com'
gitlab_rails['redis_port'] = 6380

# OR Redis via Unix domain sockets
gitlab_rails['redis_socket'] = '/tmp/redis.sock' # defaults to /var/opt/gitlab/redis/redis.socket
```

> https://docs.gitlab.com/omnibus/settings/redis.html

## Docker compose

```bash
$ docker-compose -f docker-compose.yml up -d
```
