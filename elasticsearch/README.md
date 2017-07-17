# ElasticSearch

elasticsearch:5.0.2

docker.elastic.co/elasticsearch/elasticsearch:5.0.2


## 相关

* discovery.zen

Zen 发现协议用于 ElasticSearch 发现集群中的其它节点，并建立通讯。discovery.zen.* 属性集合构成了 zen 发现协议。单播和多播均是发现协议的有效组成部分。

* 多播

多播是指当发送一个或多个请求给所有节点时，集群中的节点将被发现。

* 单播

单播是在节点和 discovery.zen.ping.unicast.hosts 中的 IP 地址之间的一对一连接。

（Elastic stack 5.0 以前，为了使单播生效，你需要将 discovery.zen.ping.multicast.enabled 设置为 false。还需要通过 discovery.zen.ping.unicast.hosts 来设置一组主机域名，其中应包含用于通信的主节点域名。）

* xpack.security.enabled

x-pack 用于权限设置，`xpack.security.enabled=false`。

* discovery.zen.minimum_master_nodes

集群操作过程中, 一个节点需要能看见（see）的最小数量的合格主节点。该值的一个计算方法是 N/2+1，N 是主节点数量。

* Master node

`node.master=true`、 `node.data=false`。

主节点的主要职责是和集群操作相关的内容，如创建或删除索引，跟踪哪些节点是群集的一部分，并决定哪些分片分配给相关的节点。稳定的主节点对集群的健康是非常重要的。

* Client node 

`node.master=false`、 `node.data=false`

当主节点和数据节点配置都设置为 false 的时候，该节点只能处理路由请求，处理搜索，分发索引操作等，从本质上来说该客户节点表现为智能负载平衡器。

* Tribe node

`node.master=false`、`node.data=false`

部落节点可以跨越多个集群，它可以接收每个集群的状态，然后合并成一个全局集群的状态，它可以读写所有节点上的数据。

* es 是如何知道文档属于哪个分片?

shard = hash(routing) % number_of_primary_shards

（routing 值是一个任意字符串，它默认是 _id 但也可以自定义）

* Kibana Timelion 查询语法

```
.es(q="querystring", metric="cardinality:uid", index="qmonitor-*", offset="-3d")
.graphite(metric="path.to.*.data", offset="-1d")
.quandl()
.worldbank_indicators() 
.wbi() 
.worldbank()
.wb()
.abs(): 绝对值
.precision($number): 浮点数精度
.testcast($count, $alpha, $beta, $gamma)
.cusum($base) 
.derivative()
.divide($divisor)
.multiply($multiplier)
.subtract($term)
.sum($term)
.add()
.plus()
.first()
.movingaverage($window)
.mvavg()
.movingstd($window)
.mvstd()
.bars($width)
.lines($width, $fill, $show, $steps)
.points()
.color("#c3c2c3")
.hide()
.label("今天数据")
.legend($position, $column)
.yaxis($yaxis_number, $min, $max, $position)
```


## Deployment

```bash
$ docker run -it --name es -p 9200:9200 -p 9300:9300 \
 -e ES_JAVA_OPTS="-Xms1g -Xmx1g" elasticsearch:5.0.2 \
 elasticsearch -Etransport.host=0.0.0.0 -Ediscovery.zen.minimum_master_nodes=1
```

## Issue

* vm.max_map_count 太小

`max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]`
> https://github.com/docker-library/elasticsearch/issues/98#issuecomment-217908274

解决办法：

我尝试增加参数 `--sysctl vm.max_map_count=262144` 依然不行。

```bash
$ sudo sysctl -w vm.max_map_count=262144
```


## ElasticSearch on mesos

mesos/elasticsearch-scheduler:1.0.1
