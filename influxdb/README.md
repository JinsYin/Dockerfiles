# influxdb

influxdb:1.0.2-alpine

与官方镜像相似的还有 `tutum/influxdb`，不过从 `0.13.0` 版本之后就不在更新了。

另外，从 `1.1.0` 版本开始 influxdb 便取消了 UI（Administrator interface），并在 `1.3.0` 版被移除。为了方便操作，我选择了官方的 `1.0.2` 版本，也可以试试 `0.13.0` 版本。


## Dockerfile

> https://github.com/influxdata/influxdata-docker/blob/master/influxdb/1.2/Dockerfile


## Deployment

`8086` 为 `HTTP API` 端口; `8083` 为 `Administrator interface` 端口, 在 1.3.0 版被移除.

```bash
$ docker run -it --name influxdb -p 8086:8086 -p 8083:8083 -v influxdb-data:/var/lib/influxdb -d influxdb:1.0.2-alpine
```

> http://localhost:8083