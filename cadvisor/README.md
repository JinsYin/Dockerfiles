# Cadvisor

google/cadvisor:v0.25.0

## Deployment

```bash
$ docker run -it --name cadvisor -p 8080:8080 -v /:/rootfs:ro -v /var/run:/var/run:rw -v /sys:/sys:ro -v /var/lib/docker/:/var/lib/docker:ro google/cadvisor:v0.25.0
```

## Document
https://github.com/google/cadvisor/blob/master/docs/storage/README.md

## Dockerfile
https://github.com/google/cadvisor/blob/master/deploy/Dockerfile


## 数据存入 es 中

```bash
$ docker run -itd -p 8080:8080 --name cadvisor \
 -v /:/rootfs:ro -v /var/run:/var/run:rw -v /sys:/sys:ro -v /var/lib/docker/:/var/lib/docker:ro google/cadvisor:v0.25.0 \
 -storage_driver=elasticsearch -storage_driver_es_host="http://master.elasticsearch.marathon.mesos:9200"
 -storage_driver_es_type="stats" -storage_driver_es_enable_sniffer=false
```
> 貌似不支持 es 5.0 [#1517](https://github.com/google/cadvisor/issues/1517)


## 数据存入 influxdb 中

```bash
$ docker run -itd -p 8080:8080 --name cadvisor \
 -v /:/rootfs:ro -v /var/run:/var/run:rw -v /sys:/sys:ro -v /var/lib/docker/:/var/lib/docker:ro google/cadvisor:v0.25.0 \
 -storage_driver=influxdb -storage_driver_host=influxdb.monitor.marathon.mesos:8086 
 -storage_driver_db=cadvisor -storage_driver_user=root -storage_driver_password=root -storage_driver_secure=false
```

> (需要事先在influxdb中创建数据库cadvisor, storage_driver_secure表示是否使用https)


## 数据存入 Prometheus 中

```bash
$ docker run -itd -p 8080:8080 --name cadvisor \
 -v /:/rootfs:ro -v /var/run:/var/run:rw -v /sys:/sys:ro -v /var/lib/docker/:/var/lib/docker:ro google/cadvisor:v0.25.0 \
 -storage_driver=prometheus -prometheus_endpoint=
```