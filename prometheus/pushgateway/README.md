# Prometheus Push Gateway

prom/pushgateway:v0.3.1

Prometheus 是通过 pull 的方式来采集数据的，也就是拉模型。但是有些数据并不适合采用这样的方式，对这样的数据可以使用 Push Gateway 服务。它就相当于一个缓存，当数据采集完成之后，就上传到这里，由 Prometheus 稍后再 pull 过来。


## Deployment

```bash
docker run -d \
  --name=pg \
  -p 9091:9091 \
  prom/pushgateway:v0.3.1
```

> http://localhost:9091


## 上传数据

```bash
$ echo "some_metric 3.14" | curl --data-binary @- http://localhost9091/metrics/job/some_job
```


## 参考

> https://qinghua.github.io/prometheus/