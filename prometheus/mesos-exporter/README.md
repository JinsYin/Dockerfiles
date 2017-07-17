# Prometheus mesos-exporter

mesosphere/mesos_exporter:latest


## Deployment

* Mesos Master

```bash
$ docker run -itd --name mesos-exporter mesosphere/mesos_exporter:latest mesos-exporter -master http://leader.mesos:5050
```

* Mesos Slave

```bash
$ docker run -itd --name mesos-exporter mesosphere/mesos_exporter:latest mesos-exporter -slave http://localhost:5051
```