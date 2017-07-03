# Calico

## Dockerfile

> https://github.com/projectcalico/calicoctl/blob/master/calico_node/Dockerfile

## Deployment 

```bash
# Restart always
$ export host_name=$(hostname)
$ export IP=$(ifconfig | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep '192.168.*.*' | head -n 1)
$ export etcd_authority="master.mesos:2379"
$ export CALICO_VERSION="v0.23.1"
$ docker run -itd --name calico-node --restart=always --net host --privileged \
 -e HOSTNAME=${host_name} \
 -e IP=${IP} \
 -e CALICO_NETWORKING_BACKEND=bird \
 -e CALICO_LIBNETWORK_ENABLED=true \
 -e ETCD_AUTHORITY=${etcd_authority} \
 -e ETCD_SCHEME=http \
 -v /var/log/calico:/var/log/calico \
 -v /run/docker/plugins:/run/docker/plugins \
 -v /lib/modules:/lib/modules \
 -v /var/run/calico:/var/run/calico \
 calico/node:${CALICO_VERSION}
```
