# ElasticSearch API

## 集群健康

> http://127.0.0.1:9200/_cat/health?v
> http://127.0.0.1:9200/_cluster/health?pretty


## 集群状态

> http://127.0.0.1:9200/_cluster/stats?pretty


## 节点状态

> http://127.0.0.1:9200/_cat/nodes?v
> http://127.0.0.1:9200/_nodes/process?pretty


## 索引列表

> http://127.0.0.1:9200/_cat/indices?v


## status 字段

> * green: 所有主要分片和复制分片都可用
> 
> * yellow: 所有主要分片可用，但不是所有复制分片都可用
> 
> * red: 不是所有的主要分片都可用


## 修改最小的主资格节点

```bash
$ curl -XPUT '127.0.0.1:9200/_cluster/settings' -H 'application/json' -d '{
	"transient": {
		"discovery.zen.minimum_master_nodes": 2
	}
}'
```


## 修改索引分片数

默认 `主分片` 的数量为 5 个，表示 1 个索引有 5 个主分片。`主分片` 的数量只能在创建索引时定义且不能修改。
默认 `复制分片` 的数量为 1 个, 表示：1 个主分片有 1 个复制分片。

* 查询主分片数及其复制分片数

```json
GET /blogs
{
   "settings" : {
      "number_of_shards" : 3,
      "number_of_replicas" : 1
   }
}
```


* 修改主分片的复制分片数

```json
PUT /blogs/_settings
{
	"number_of_replicas" : 2
}
```