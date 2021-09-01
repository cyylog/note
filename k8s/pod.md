[toc]

一般情况下我们部署的Pod是通过集群自动调度选择某个节点的，默认情况下调度器考虑的是资源足够，并且负载尽量平均，但是有时候我们需要能够更加细粒度的去控制Pod的粒度，这时候我们可能不希望一些对外的服务和内部服务跑在同一个节点上；有的时候两个服务之间交流比较频繁，又希望将这两个服务的Pod调度到同样的节点上。这就需要用到亲和性和反亲和性。



#### 节点亲和性

节点亲和性概念上类似豫`nodeSelector`，它使你可以根据节点上的标签来约束Pod可以调度到哪些节点。

目前有两种类型的节点亲和性：

* `requiredDuringSchedulingIgnoredDuringExecution`：指定了将Pod调度到一个节点上必须满足的规则
* `preferredDuringSchedulingIgnoredDuringExecution`：指定调度器将尝试执行但不能保证的偏好。

> 节点亲和性通过 PodSpec 的 `affinity` 字段下的 `nodeAffinity` 字段进行指定。



#### Pod间亲和性与反亲和性

> Pod 间亲和性通过 PodSpec 中 `affinity` 字段下的 `podAffinity` 字段进行指定。 而 Pod 间反亲和性通过 PodSpec 中 `affinity` 字段下的 `podAntiAffinity` 字段进行指定。



```yaml
{
  "podAffinity": {
    "preferredDuringSchedulingIgnoredDuringExecution": [
      {
        "weight": 100,
        "podAffinityTerm": {
          "labelSelector": {
            "matchExpressions": [
              {
                "key": "appbind/[InstanceName]",
                "operator": "In",
                "values": [
                  "true"
                ]
              }
            ]
          },
          "topologyKey": "kubernetes.io/hostname"
        }
      }
    ]
  }
}
```

##### 表达式

* weight：weight值从1-100表示权重，值越大被选中的几率越大

operator 的值可选的操作符有：

- In：label 的值在某个列表中
- NotIn：label 的值不在某个列表中
- Exists：某个 label 存在
- DoesNotExist: 某个 label 不存在
- Gt：label 的值大于某个值（字符串比较）
- Lt：label 的值小于某个值（字符串比较



#### 存活检查和就绪检查

* 就绪检查：一个应用需要一段时间来预热和启动，应用在完全就绪之前不应接收流量，但默认情况下，Kubernetes会在容器内的进程启动后立即开始发送流量。通过就绪探针探测，直到应用程序完全启动，然后才允许将流量发送到新副本。

* 存活检查：当我们的应用在成功启动以后因为一些原因“宕机”，或者遇到死锁情况，导致它无法响应用户请求。在默认情况下，Kubernetes会继续向Pod发送请求，通过使用存活探针来检测，当发现服务不能在限定时间内处理请求（请求错误或者超时），就会重新启动有问题的pod。

  