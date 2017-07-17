# Grafana

grafana/grafana:4.1.2


## Dockerfile

> https://github.com/grafana/grafana-docker/blob/master/Dockerfile


## Deployment

用户名/密码：`admin/admin`

```bash
$ docker run -itd --name grafana -p 3000:3000 \
 -e "GF_SERVER_ROOT_URL=http://localhost" \
 -e "GF_SECURITY_ADMIN_PASSWORD=admin" \
 -v grafana-data:/var/lib/grafana \
 -v grafana-log:/var/log/grafana \
 -v grafana-config:/etc/grafana grafana/grafana:4.1.2
```

docker run -itd --name grafana-311 -p 3110:3000 \
 -e "GF_SERVER_ROOT_URL=http://localhost" \
 -e "GF_SECURITY_ADMIN_PASSWORD=admin" \
 -v grafana-data:/var/lib/grafana \
 -v grafana-log:/var/log/grafana \
 -v grafana-config:/etc/grafana grafana/grafana:3.1.1

## 