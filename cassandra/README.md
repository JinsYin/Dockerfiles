# Cassandra

## Deployment

单机部署

- cassandra-1

```
$ docker run -it --name cassandra-1 \
 --ulimit nofile=40960:102400 \
 -v cassandra_data_1:/var/lib/cassandra \
 -e CASSANDRA_CLUSTER_NAME=CassandraCluster \
 -e CASSANDRA_DC=dc1 \
 -e CASSANDRA_RACK=rack1 \
 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch \
 -p 7000:7000 -p 7001:7001 -p 7199:7199 -p 9042:9042 -d cassandra:3.9
```

- cassandra-2

```
$ docker run -it --name cassandra-2 \
 --ulimit nofile=40960:102400 \
 -v cassandra_data_2:/var/lib/cassandra \
 -e CASSANDRA_CLUSTER_NAME=CassandraCluster \
 -e CASSANDRA_DC=dc1 \
 -e CASSANDRA_RACK=rack1 \
 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch \
 --link cassandra-1:cassandra -d cassandra:3.9
```
