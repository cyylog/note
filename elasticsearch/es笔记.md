[TOC]

#### es里基础概念：

###### _index（索引）：文档在哪存放

> 实际上，在elasticsearch中，我们的数据是被存储和索引在分片中，而一个索引仅仅是逻辑上的命名空间，这个命名空间由一个或多个分片组合在一起。
>
> *索引名必须小写，不能以下划线开头，不能包含逗号*

```shell
/_search										在所有的索引中搜索所有的类型
/gb/_search									在gb索引中搜索所有类型
/gb,us/_search							在gb和us索引中搜索所有的文档
/g*,u*/_search							在任何以g或者u开头的索引中搜索所有的类型
/gb/user/_search						在gb索引中搜索user类型
/gb,us/user,tweet/_search		在gb和us索引中搜索user和tweet类型的文档
/_all/user,tweet/_search		在所有索引中搜索user和tweet类型的文档
```

###### _type（类型）：文档表示的对象类别

> *一个_type命名可以是大写或者小写，但是不能以下划线或者句号开头，不能包含逗号，并且长度限制为256个字符*

###### _id（id）：文档唯一标识

> *ID* 是一个字符串，当它和 `_index` 以及 `_type` 组合就可以唯一确定 Elasticsearch 中的一个文档。 当你创建一个新的文档，要么提供自己的 `_id` ，要么让 Elasticsearch 帮你生成。
>
> *当你使用指定的id时，请求方式使用`PUT`方式，当没有指定id时，要使用`POST`方式，这时elasticsearch会自动生成`_id`，自动生成的 ID 是 URL-safe、 基于 Base64 编码且长度为20个字符的 GUID 字符串。*

##### 分页：

###### size

显示应该返回的结果数量，默认是*10*

###### from

显示应该跳过的初始结果数量，默认是10

```json
GET /_search?size=5
GET /_search?size=5&from=10
```

##### 查询全部

```json
GET /_search?q=bob		//查询所有包含bob的文档
```

##### math单字段查询

```json
GET /test/_search
{
  "query": {
    "match": {
      "age": 25	//这里是要从哪个字段，和查询的值是什么，相当于mysql里 select * from table where name=25
    }
  }
}

```

##### multi_match多字段查询

```json
GET /test/_search
{
  "query": {
    "multi_match": {
      "query": "jerry",									//query字段表示要查找的值
      "fields": ["abort","last_name"]		//fields表示要从哪些字段中找到这些值
    }
  }
}


```

##### range查询

```json
GET /test/_search
{
  "query": {
    "range": {
      "age": {
        "gte": 20,
        "lte": 35
      }
    }
  }
}

被允许的操作符如下：
gt：大于
gte：大于等于
lt：小于
lte：小于等于
```

##### term精准查询

```json
GET /test/_search
{
  "query": {
    "term": {
      "abort": {
        "value": "he"
      }
    }
  }
}    
注：这里value匹配的是abort字段里包含 he 的值，term一次只能加一个查询条件
```

##### terms查询

```json
GET /test/_search
{
  "query": {
    "terms": {
      "last_name": [
        "bob",
        "jerry"
      ]
    }
  }
}
注：这里terms查询的是一个字段包含的多个值
```

##### exists查询

```json
GET /test/_search
{
  "query": {
    "exists": {
      "field": "last_name"
    }
  }
}
注：这里是查询是否包含 last_name 这个字段
```

##### match查询中提高精度查询

```json
GET /my_index/my_type/_search
{
  "query": {
    "match": {
      "title":  "brown dog"		//这样查询是只要包含brown或者dog的数据列都会被查询出来
    }
  }
}

GET /my_index/my_type/_search
{
  "query": {
    "match": {
      "title": {
        "query": "brown dog",		//这样查询时相当于and查询，必须都包含query条件才会查询出来
        "operator": "and"
      }
    }
  }
}
```

##### multi_match多匹配查询

```json
GET /_search
{
  "query": {
    "multi_match": {
      "query": "Quick brown fox",
      "fields": ["title","body"]   // 查询title和body字段中包含query里的值的数据
      
      ---
      "query": "Quick brown fox",
      "fields": "*_title" 		// 字段模糊查询
    }
  }
}


```





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

*对同一个/_index/_tpye/_id进行PUT操作时，首次PUT是新增操作，后面的PUT操作时update操作*



###### 更新整个文档：

在elasticsearch中文档是*不可改变的*，不能修改他们。相反，如果想要更新现有的文档，需要重建*索引*或者进行替换，可以使用相同的`index`API进行实现

```json
curl -X PUT 'localhost:9200/student/class/2?pretty' -H 'Content-Type:application/json' -d '
{
    "name":"tom",
    "age":18,
    "score":59
}
'
```

返回结果：

```json
{
  "_index" : "student",
  "_type" : "class",
  "_id" : "2",
  "_version" : 2,
  "result" : "updated",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 6,
  "_primary_term" : 1
}
```

> 在内部，elasticsearch已将旧文档标记为已删除，并增加一个全新的文档。尽管你不能再对旧的文档进行访问，但它并不会立即消失。当继续索引更多的数据，elasticsearch会在后台清理这些已删除的文档。




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

*GET查询时，如果不指定文档id，使用_search查询，表示查询该索引类型下所有的文档*



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

*这里使用了过滤器，去查找年龄大于25岁的文档，其中 *gt*表示大于*



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



######匹配查询，也称match查询：

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

> 1. match查询会hui先对搜索词进行分词，分词完毕后再对分词的结果集进行匹配。==term是单词精确搜索，match是分词匹配搜索。==
> 2. match搜索可以按照anzhao分词后的分词集合的or或者huozheand进行匹配，==默认为or==，也是为什么默认只要有一个分词出现在文档中就会被搜索出来，同样的，如果我们希望是所有分词都要出现，那只要把匹配模式改成and就行了
>
> ```json
> {
>   "query": {
>     "match": {
>       "tags": {
>         "query": "Hello World",
>         "operator": "and"
>       }
>     }
>   }
> } 
> ```



###### 词项查询，也称term查询:

```json
curl -X GET 'localhost:9200/student/_search' -H 'Content-Type:application/json' -d'
{
	"query":{
		"term":{
			"name":"tom"		//这里是指定搜索name为tom 的值
		}
	}
}'
```

```json
{
    "took": 2,
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
        "max_score": 0.9808292,
        "hits": [
            {
                "_index": "student",
                "_type": "class",
                "_id": "2",
                "_score": 0.9808292,
                "_source": {
                    "name": "tom",
                    "age": 18,
                    "score": 59
                }
            }
        ]
    }
}
```

==term代表完全匹配，也是精确查询，搜索钱不会再对搜索词进行分词fenci，所以搜索词必须是`文档分词集合中的一个`==

1. 如果建立索引时，该字段无分词，那么term完全匹配搜索到的字段
2. 如果建立索引时，该字段进行了分词，比如`hello world`这个因为是两个单词，所以就进行了分词，搜索时只能搜索`hello`或者`world`，不能直接搜索`hello world`



###### 获取头部信息（-i）：

```json
请求示例：
curl -i -X GET 'http://localhost:9200/student/class/1?pretty'

返回示例：
HTTP/1.1 200 OK
content-type: application/json; charset=UTF-8
content-length: 216

{
  "_index" : "student",
  "_type" : "class",
  "_id" : "1",
  "_version" : 2,
  "_seq_no" : 2,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "name" : "jerry",
    "age" : 22,
    "score" : 100
  }
}

```

*通过传递 `-i`参数给`curl`命令，该参数能显示响应的头部*



###### 返回文档的一部分：

> 默认情况下，`GET`请求会返回整个文档，如果只对其中定义的字段感兴趣，可以使用`_source`参数，多个字段可以使用逗号进行分隔

```json
请求示例：
curl -X GET 'http:/localhost:9200/student/class/1?_source=name,age'

返回示例：
{
    "_index": "student",
    "_type": "class",
    "_id": "1",
    "_version": 2,
    "_seq_no": 2,
    "_primary_term": 1,
    "found": true,
    "_source": {
        "name": "jerry",
        "age": 22
    }
}

```

> 只返回自定义的字段

```json
请求示例：
curl -X GET 'http:/localhost:9200/student/class/1/_source'

返回示例：
{
    "name": "jerry",
    "age": 22,
    "score": 100
}
```



###### 检查文档是否存在（-XHEAD）：

> 如果只想检查一个文档是否存在--根本不想关心内容—那么用`HEAD`方法来代替`GET`方法。

```json
curl -i -XHEAD http://localhost:9200/student/class/1
```

> 如果文档存在，elasticsearch将返回一个`200 ok`的状态码：

```json 
HTTP/1.1 200 OK
Warning: 299 Elasticsearch-7.3.0-de777fa "[types removal] Specifying types in document get requests is deprecated, use the /{index}/_doc/{id} endpoint instead."
content-type: application/json; charset=UTF-8
content-length: 157
```

> 如果文档不存在，elasticsearch将返回一个`404 Not Found`的状态码

```json
curl -i -XHEAD http://localhost:9200/student/class/5
```

```json
HTTP/1.1 404 Not Found
Warning: 299 Elasticsearch-7.3.0-de777fa "[types removal] Specifying types in document get requests is deprecated, use the /{index}/_doc/{id} endpoint instead."
content-type: application/json; charset=UTF-8
content-length: 60
```





##### Update:

首先新建一个简单的文档：

```json
curl -X PUT 'http://localhost:9200/test/_doc/1' -H 'Content-Type:application/json' -d'
{
    "counter":1,
    "tags":["red"]
}'
```

######通过脚本增加计数器：

```json
curl -X POST 'http://localhost:9200/test/_update/1' -H 'Content-Type:application/json' -d'
{
    "script":{
        "source":"ctx._source.counter += parmas.count",
        "lang":"painless",	//可选，默认painless
        "params":{
            "count":4
        }
    }
}'
```

这时候再查询原来的文档的话，会发现`counter`的值已经变成了5。

###### 向数组里添加数据：

```json
curl -X POST 'http://localhost:9200/test/_update/1' -H "Content-Type:application/json" -d'
{
    "script":{
        "source":"ctx._source.tags.add(params.tag)",
        "lang":"painless",
        "params":{
            "tag":"blue"
        }
    }
}'
```

###### 从数组中删除数据：

```json
curl -X POST 'http://localhost:9200/test/_doc/1?pretty' -H 'Content-Type:application/json' -d'
{
    "script":{
        "source":"if(ctx._source.tags.contains(params.tag)) {ctx._source.tags.remove(ctx._source.tags.indexOf(params.tag))}",
        "lang":"painless",
        "params":{
            "tag":"blue"
        }
    }
}'
```

*想要删除数组中的某个元素时，要先获取这个元素在数组中对应的index。*

*如果数组中包含重复的要删除的元素，该脚本只会删除其中的一个。*

######新增字段：

```json
curl -X POST "localhost:9200/test/_update/1?pretty" -H 'Content-Type: application/json' -d'
{
    "script" : "ctx._source.new_field = 'value_of_new_field'"
}
'

```

该脚本会在原来的文档中新增一条字段，字段名称为`new_filed`，值为`value_of_new_field`

###### 通过脚本删除文档：

```json
curl -X POST 'http://localhost:9200/test/_doc/1?pretty' -H -d'
{
    "script":{
        "source":"if(ctx._source.tags.contains(params.tag)) {ctx.op='delete'} else {ctx.op='none'}"
    },
    "lang":"painless",
    "params":{
        "tag":"green"
    }
}'
```

> 如果/test/_doc/1这个文档里的tags数组里有green值，就会删除该文档，否则就返回`noop`(表示不做任何事情)



###### 向文档新增字段：

```json
curl -X POST "localhost:9200/test/_update/1?pretty" -H 'Content-Type: application/json' -d'
{
    "doc" : {
        "name" : "new_name"
    }
}
'
```

该命令会在原来的文档中新增一条字段，字段名称为`name`，值为`new_name`

==如果同时指定了`doc`和`script`，`doc`将被忽略。==



###### upsert:(更新或插入)

> 如果文档不存在，`upsert`元素的内容将作为新文档插入。

```json
curl -X POST "localhost:9200/test/_update/1?pretty" -H 'Content-Type: application/json' -d'
{
    "script" : {
        "source": "ctx._source.counter += params.count",
        "lang": "painless",
        "params" : {
            "count" : 4
        }
    },
    "upsert" : {
        "counter" : 1
    }
}
'
```

###### Scripted upsert:(通过脚本更新或插入)

> 要在文档是否存在的情况下运行脚本，请将脚本化的`upsert`设置为true

```json
curl -X POST "localhost:9200/sessions/_update/dh3sgudg8gsrgl?pretty" -H 'Content-Type: application/json' -d'
{
    "scripted_upsert":true,
    "script" : {
        "id": "my_web_session_summariser",
        "params" : {
            "pageViewEvent" : {
                "url":"foo.com/bar",
                "response":404,
                "time":"2014-01-01 12:32"
            }
        }
    },
    "upsert" : {}
}
'
```









##### 创建新文档:

##### 确保创建一个新文档的最简单办法是，使用索引的`POST`形式让elasticsearch自动生成唯一`_id`:

```json
curl -X POST 'http://localhost:9200/student/class/' -H 'Content-Type:application/json' -d '
{
    "name":"jerry2",
    "age":20,
    "score":90
}'
```



> 然而，如果已经有自己的 `_id` ，那么我们必须告诉 Elasticsearch ，只有在相同的 `_index` 、 `_type` 和 `_id` 不存在时才接受我们的索引请求。

###### 第一种方法使用`_op_type`查询-字符串参数：

```json
PUT /student/class/123?op_type=create
{...}
```

第二中方法是在URL末端使用`/_create`:

```json
PUT /student/class/123/_create
{....}
```



##### 删除文档：

```json
curl -X DELETAE 'http://localhost:9200/student/class/3'


```



> 如果找到该文档，elasticsearch将返回一个`200 ok`的HTTP响应码，注意`_version`值已经增加：

```json
{
    "_index":"student",
    "_type":"class",
    "_id":"3",
    "_version":2,
    "result":"deleted",
    "_shards":{
        "total":2,
        "successful":1,
        "failed":0
    },
    "_seq_no":8,
    "_primary_term":1
}
```

> 如果文档没有找到，我们将得到`404 NOT FOUND`的响应码和这样类似的响应体：

```json
{
  "found" :    false,
  "_index" :   "website",
  "_type" :    "blog",
  "_id" :      "123",
  "_version" : 4
}
```

*删除文档不会立即从磁盘中删除，只是将文档标记为已删除状态。*





##### 批量操作`_bulk`：

###### 批量导入:

```json
curl -X POST "localhost:9200/_bulk?pretty" -H 'Content-Type: application/json' -d'
{ "index" : { "_index" : "test", "_id" : "1" } }
{ "field1" : "value1" }
{ "delete" : { "_index" : "test", "_id" : "2" } }
{ "create" : { "_index" : "test", "_id" : "3" } }
{ "field1" : "value3" }
{ "update" : {"_id" : "1", "_index" : "test"} }
{ "doc" : {"field2" : "value2"} }
'
```

*批量操作，包含索引、删除、更新、新增*





####es乐观并发控制

> 我们可以使用`_version`号来确保应用中相互冲突的变更不会导致数据丢失。通过指定想要修改的文档`version`来达到这个目的。如果该版本不是当前版本号，请求将会失败。

```json
curl -X PUT "localhost:9200/website/blog/1?version=2&pretty" -H 'Content-Type: application/json' -d'
{
  "title": "My first blog entry",
  "text":  "Starting to get the hang of this..."
}
'
```

*当指定的更新版本号小于等于当前版本号时，会响应失败，也就是说指定的更新版本号，要大于当前版本号*

```json
{
      "error": {
      "root_cause": [
         {
            "type": "version_conflict_engine_exception",
            "reason": "[blog][1]: version conflict, current [2], provided [1]",
            "index": "website",
            "shard": "3"
         }
      ],
      "type": "version_conflict_engine_exception",
      "reason": "[blog][1]: version conflict, current [2], provided [1]",
      "index": "website",
      "shard": "3"
   },
   "status": 409
}
```

==其实就是es在告诉你，你当前更改的这个版本已经被人改过了。==





#### Mapping

##### 什么是映射

>  类似于数据库中的表结构定义，主要作用如下：
>
> * 定义Index下字段名(Field Name)
> * 定义字段的类型，比如数值型，字符串型、布尔型等
> * 定义倒排索引的相关配置，比如是否索引、记录postion等
>
> 需要注意的是，在索引中定义太多字段可能会导致索引膨胀，出现内存不足和难以恢复的情况，下面有几个设置：
>
> - index.mapping.total_fields.limit：一个索引中能定义的字段的最大数量，默认是 1000
> - index.mapping.depth.limit：字段的最大深度，以内部对象的数量来计算，默认是20
> - index.mapping.nested_fields.limit：索引中嵌套字段的最大数量，默认是50

##### Mapping的数据类型

> 基本数据类型

| 属性名字   | 说明                                                         |
| :--------- | ------------------------------------------------------------ |
| text       | 用于全文索引，该类型的字段将通过分词器进行分词，最终用于构建索引 |
| keyword    | 不分词                                                       |
| long       | 有符号64-bit integer: -2^63 ~ 2^63-1                         |
| integer    | 有符号32-bit integer：-2^31 ~ 2^31-1                         |
| short      | 有符号16-bit integer：-32768 ~ 32767                         |
| byte       | 有符号8-bit integer：-128 ~ 127                              |
| double     | 64-bit IEEE 754 浮点数                                       |
| float      | 32-bit IEEE 754 浮点数                                       |
| half_float | 16-bit IEEE 754 浮点数                                       |
| boolean    | true,false                                                   |
| date       |                                                              |
| binary     | 该类型的字段把值当做经过 base64 编码的字符串，默认不存储，且不可搜索 |

> Mapping范围数据类型

| 支持的数据类型 | 说明                                    |
| -------------- | --------------------------------------- |
| integer_range  |                                         |
| float_range    |                                         |
| long_range     |                                         |
| double_range   |                                         |
| date_range     | 64-bit 无符号整数，时间戳（单位：毫秒） |
| ip_range       | IPV4 或 IPV6 格式的字符串               |

可选参数:

relation这只匹配模式

INTERSECTS 默认的匹配模式，只要搜索值与字段值有交集即可匹配到

WITHIN 字段值需要完全包含在搜索值之内，也就是字段值是搜索值的子集才搜索出来

CONTAINS 与WITHIN相反，只搜索字段值包含搜索值的文档







kubernetes类型：

```json
"kubernetes.namespace.keyword":"junhui-dsp"
"kubernetes.pod.name.keyword":"mynginx-ff4dc7896-mv4g4"
单pod
"kubernetes.container.name.keyword":["mynginx"]
多pod
kubernetes.pod.name.keyword

rang：
from、to

sort:
timestamp、_id
```

ocp类型：

```json
{
    "took": 30,
    "timed_out": false,
    "_shards": {
        "total": 5,
        "successful": 5,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": 1,
        "max_score": null,
        "hits": [
            {
                "_index": "containers-2021.08.18",
                "_type": "doc",
                "_id": "zqvvWHsBJD6vSnutUBVC",
                "_score": null,
                "_source": {
                    "stream": "stdout",
                    "agent": {
                        "id": "267f5ccd-78d1-4c8e-a570-e33f8bc694fa",
                        "hostname": "filebeat-nrt2r",
                        "name": "filebeat-nrt2r",
                        "ephemeral_id": "e5f9c334-7a82-4b54-8a1e-df97dfc172d2",
                        "version": "7.13.0",
                        "type": "filebeat"
                    },
                    "tags": [
                        "container",
                        "beats_input_codec_plain_applied"
                    ],
                    "ecs": {
                        "version": "1.8.0"
                    },
                    "container": {
                        "id": "44d9fc52c6ab7cdc80fab74d3cf5b183fc050ff2d283a6ad7b6fe8c000bcc9f6",
                        "image": {
                            "name": "10.23.101.13/bbbb/dao-2048:latest"
                        },
                        "runtime": "docker"
                    },
                    "@timestamp": "2021-08-18T11:04:19.651Z",
                    "host": {
                        "name": "filebeat-nrt2r"
                    },
                    "message": "172.29.19.0 - - [18/Aug/2021:11:04:19 +0000] \"GET / HTTP/1.1\" 200 4094 \"-\" \"curl/7.29.0\"",
                    "kubernetes": {
                        "namespace_uid": "0fd96b27-0a93-4f0f-a1c7-47cd38c66761",
                        "namespace": "panguicai-dev-multicloudapp",
                        "replicaset": {
                            "name": "dao-2048-dao-2048-7945b8d44b"
                        },
                        "container": {
                            "name": "dao-2048-dao-2048"
                        },
                        "labels": {
                            "pod-template-hash": "7945b8d44b",
                            "dce_daocloud_io/component": "dao-2048-dao-2048",
                            "dce_daocloud_io/app": "dao-2048"
                        },
                        "node": {
                            "hostname": "dce-10-23-5-4",
                            "name": "dce-10-23-5-4",
                            "labels": {
                                "dx-insight_daocloud_io": "",
                                "io_daocloud_dce_dns": "",
                                "kubernetes_io/os": "linux",
                                "kubernetes_io/hostname": "dce-10-23-5-4",
                                "kubernetes_io/arch": "amd64",
                                "infra": "elk",
                                "zookeeper": "true",
                                "beta_kubernetes_io/arch": "amd64",
                                "elasticsearch": "true",
                                "beta_kubernetes_io/os": "linux",
                                "kafka": "true",
                                "nginx": "true",
                                "rocketmq": "true",
                                "node_loadbalancer_dce_daocloud_io/lb01": "enabled",
                                "node-role_kubernetes_io/infrastructure": "",
                                "rabbitmq": "true"
                            },
                            "uid": "89b92445-6cfe-494e-8026-919af1a2628b"
                        },
                        "pod": {
                            "name": "dao-2048-dao-2048-7945b8d44b-tmm2x",
                            "ip": "172.29.80.15",
                            "uid": "0634d55d-dfa8-4d12-a787-e0c717557a19"
                        },
                        "deployment": {
                            "name": "dao-2048-dao-2048"
                        }
                    },
                    "@version": "1"
                },
                "sort": [
                    1629284659651
                ]
            }
        ]
    }
}
```















```json
{
    "query":{
        "bool":{
            "must":[
                {
                    "term":{
                        "kubernetes.namespace.keyword":"junhui-dsp"
                    }
                },
                {
                    "term":{
                        "kubernetes.pod.name.keyword":"mynginx-ff4dc7896-mv4g4"
                    }
                },
                {
                    "terms":{
                        "kubernetes.container.name.keyword":[
                            "mynginx"
                        ]
                    }
                },
                {
                    "range":{
                        "@timestamp":{
                            "from":"1628697600000",
                            "include_lower":true,
                            "include_upper":true,
                            "to":"1629278695726"
                        }
                    }
                }
            ]
        }
    },
    "size":100,
    "sort":[
        {
            "@timestamp":{
                "order":"desc"
            }
        },
        {
            "_id":{
                "order":"desc"
            }
        }
    ]
}
```





