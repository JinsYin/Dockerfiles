# Prometheus

prom/prometheus:v1.4.1

Prometheus 是一个开源的监控解决方案，包括数据采集、汇聚、存储、可视化、监控、告警等。除了自身基本的监控数据，也支持通过自定义 exporter 来获取自己想要的数据。


## Dockerfile

> https://github.com/prometheus/prometheus/blob/v1.4.1/Dockerfile


## Deployment

```bash
$ docker run -itd --name prometheus -p 9090:9090 -v prometheus-data:/prometheus prom/prometheus:v1.4.1
```

> [图表](http://localhost:9090/graph)
> [自身监控](http://localhost:9090/metrics)
> [监控对象](http://localhost:9090/targets)


## Exporter

> [node-exporter](./node-exporter/README.md)
>
> [jmx-exporter](./jmx-exporter/README.md)
>
> [mysqld-exporter](./mysqld-exporter/README.md)

Node/system metrics exporter
AWS CloudWatch exporter
Blackbox exporter
Collectd exporter
Consul exporter
Graphite exporter
HAProxy exporter
InfluxDB exporter
JMX exporter
Memcached exporter
Mesos task exporter
MySQL server exporter
SNMP exporter
StatsD exporter


## Alert-Manager

[alertmanager](./alertmanager/README.md)
