[TOC]



####es里基础概念：

###### _index（索引）：文档在哪存放

> 实际上，在elasticsearch中，我们的数据是被存储和索引在分片中，而一个索引仅仅是逻辑上的命名空间，这个命名空间由一个或多个分片组合在一起。
>
> ==索引名必须小写，不能以下划线开头，不能包含逗号==

######_type（类型）：文档表示的对象类别

> ==一个_type命名可以是大写或者小写，但是不能以下划线或者句号开头，不能包含逗号，并且长度限制为256个字符==

######_id（id）：文档唯一标识

> *ID* 是一个字符串，当它和 `_index` 以及 `_type` 组合就可以唯一确定 Elasticsearch 中的一个文档。 当你创建一个新的文档，要么提供自己的 `_id` ，要么让 Elasticsearch 帮你生成。
>
> ==当你使用指定的id时，请求方式使用`PUT`方式，当没有指定id时，要使用`POST`方式，这时elasticsearch会自动生成`_id`，自动生成的 ID 是 URL-safe、 基于 Base64 编码且长度为20个字符的 GUID 字符串。==



#### es基本操作：

##### PUT操作：

```json
请求示例：

curl -X PUT 'http://localhost:9200/student/class/1' -H 'Content-Type:application/json' -d '
{
    "name":"jerry",
    "age":22,
    "score":99.9
}
'
```

```json
返回示例：
{
    "_index": "student",
    "_type": "class",
    "_id": "1",
    "_version": 1,
    "result": "created",
    "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
    },
    "_seq_no": 1,
    "_primary_term": 1
}
```
| _index  | _type | _id    |
| ------- | ----- | ------ |
| student | class | 1      |
| 索引    | 类型  | 文档id |

==对同一个/_index/_tpye/_id进行PUT操作时，首次PUT是新增操作，后面的PUT操作时update操作==


##### GET操作：

```json
请求示例：
curl -X GET 'http://localhost:9200/student/class/_search'


返回示例：
{
    "took": 1,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 2,
            "relation": "eq"
        },
        "max_score": 1,
        "hits": [
            {
                "_index": "student",
                "_type": "class",
                "_id": "1",
                "_score": 1,
                "_source": {
                    "name": "jerry",
                    "age": 22,
                    "score": 100
                }
            },
            {
                "_index": "student",
                "_type": "class",
                "_id": "2",
                "_score": 1,
                "_source": {
                    "name": "tom",
                    "age": 23,
                    "score": 10
                }
            }
        ]
    }
}
```

==GET查询时，如果不指定文档id，使用_search查询，表示查询该索引类型下所有的文档==



```json
请求示例：
curl -x GET 'http://localhost:9200/student/class/_search?q=name:jerry'


返回示例：
{
    "took": 1,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 1,
            "relation": "eq"
        },
        "max_score": 0.6931472,
        "hits": [
            {
                "_index": "student",
                "_type": "class",
                "_id": "1",
                "_score": 0.6931472,
                "_source": {
                    "name": "jerry",
                    "age": 22,
                    "score": 100
                }
            }
        ]
    }
}
```



###### 使用查询表达式搜索：

```json
请求示例：
curl -X GET "localhost:9200/student/class/_search" -H 'Content-Type: application/json' -d'
{
    "query" : {
        "match" : {
            "age" : 23
        }
    }
}
'

返回示例：
{
    "took": 1,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 1,
            "relation": "eq"
        },
        "max_score": 1,
        "hits": [
            {
                "_index": "student",
                "_type": "class",
                "_id": "2",
                "_score": 1,
                "_source": {
                    "name": "tom",
                    "age": 23,
                    "score": 10
                }
            }
        ]
    }
}
```



###### 过滤条件搜索

```json
请求示例：

curl -X GET 'http://localhost:9200/student/class/_search' -H 'Content-Type:application/json' -d '
{
    "query":{
        "bool":{
            "must":{
                "match":{
                    "name":"jerry"
                }
            },
            "filter":{
                "range":{
                    "age":{
                        "gt":25
                    }
                }
            }
        }
    }
}
'
```

==这里使用了过滤器，去查找年龄大于25岁的文档，其中 *gt*表示大于==



###### 短语搜索：match_phrase

```json
请求示例：
curl -X GET "localhost:9200/megacorp/employee/_search?pretty" -H 'Content-Type: application/json' -d'
{
    "query" : {
        "match_phrase" : {
            "about" : "rock climbing"
        }
    }
}
'

返回示例：
{
    "took": 1,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 1,
            "relation": "eq"
        },
        "max_score": 0.2876821,
        "hits": [
            {
                "_index": "megacorp",
                "_type": "employee",
                "_id": "2",
                "_score": 0.2876821,
                "_source": {
                    "first_name": "jerry",
                    "last_name": "tom",
                    "age": 24,
                    "about": "i want a job",
                    "intersts": [
                        "watching",
                        "music"
                    ]
                }
            }
        ]
    }
}
```

==不使用短语搜索的时候，可能会返回多个个别字段匹配的结果，短语搜索，只返回全部匹配的结果==



###### 高亮搜索：highlight

```json
请求示例：
curl -X GET 'http://localhost:9200/megacorp/employee/_search' -H 'Content-Type:application/json' -d '
{
	"query":{
		"match":{
			"first_name":"jerry"
		}
	},
	"highlight":{
		"fields":{
			"first_name":{}
		}
	}
}
'
返回示例：
{
    "took": 63,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 1,
            "relation": "eq"
        },
        "max_score": 0.6931472,
        "hits": [
            {
                "_index": "megacorp",
                "_type": "employee",
                "_id": "2",
                "_score": 0.6931472,
                "_source": {
                    "first_name": "jerry",
                    "last_name": "tom",
                    "age": 24,
                    "about": "i want a job",
                    "intersts": [
                        "watching",
                        "music"
                    ]
                },
                "highlight": {
                    "first_name": [
                        "<em>jerry</em>"
                    ]
                }
            }
        ]
    }
}
```



