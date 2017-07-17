# Prometheus node-exporter

prom/node-exporter:v0.13.0


## Dockerfile

> https://github.com/prometheus/node_exporter/blob/v0.13.0/Dockerfile)


## Deployment

```bash
$ docker run -itd --name node-exporter -p 9100:9100 --net=host prom/node-exporter:v0.13.0
```

> http://localhost:9100/metrics


## Grafana dashboards

> [Docker and system monitoring（893）](https://grafana.com/dashboards/893)