# Chronos

mesosphere/chronos:v3.0.2

## Deployment

```bash
$ docker run --net=host -e PORT0=8080 -e PORT1=8081 mesosphere/chronos:v3.0.2 --zk_hosts $zk_ip:2181 --master zk://$zk_ip:2181/mesos
```