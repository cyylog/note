[TOC]

##### k8s概念：

​	在kubernetes集群中，有master和node两个角色。

```json
Master主要负责整个集群的管理控制。
Node负责集群中的各个工作节点。Node由Master管理，提供运行容器所需的各种环境，对容器进行实际的控制，而这些容器会提供实际得到应用服务。
```





* Pod：
  * Pod是k8s里能够被运行的最小的逻辑单元（原子单元）
  * 1个Pod里面可以运行多个容器，它们共享UTS+NET+IPC名称空间
  * 可以把Pod理解成豌豆荚，而同一个Pod内的每个容器是一颗颗豌豆
  * 一个Pod里面可以运行多个容器，又叫边车模式
* Pod控制器：
  * Pod控制器是Pod启动的一个模板，用来保证在k8s里启动的Pod应始终按照人们的预期运行（副本数、生命周期、健康状态检查。。。）
  * k8s内提供了众多的pod控制器，常用的有如下几种:
    * Depolyment
    * DaemonSet
    * ReplicaSet
    * StatefulSet
    * Job
    * CronJob
* Name:
  * 由于k8s内部，使用”资源“来定义每一种逻辑概念（功能），所以每种”资源“，都应该有自己的名称
  * ”资源"有api版本（apiVersion）、类别（kind）、元数据（metadata）、定义清单（spec）、状态（status）等配置信息
  * “名称”通常定义在“资源“的”元数据“信息里
* NameSpace：
  * 随着项目增多、人员增加、集群规模的扩大，需要一种能够隔离k8s内各种”资源“的方法，这就是==名称空间==
  * 名称空间可以理解为k8s内部的虚拟集群组
  * 不同名称空间内的”资源“，名称可以相同，相同名称空间内的”资源“，名称不能相同
  * 合理的使用k8s的名称空间，使得集群管理员能够更好的对交付到k8s里的服务进行分类管理和浏览
  * k8s里默认存在的名称空间有：default、kube-system、kube-public
  * 查询k8s里特定”资源“要带上相应的名称空间
* Label：
  * 标签是k8s特色的管理方式，便于分类管理资源对象
  * 一个标签可以对应多个资源，一个资源也可以有多个标签，它们是多对多的关系
  * 一个资源拥有多个标签，可以实现不同维度的管理
  * 标签的组成：key=value
  * 与标签类似的，还有一种注解（annotations）
* Label选择器：
  * 给资源打上标签后，可以使用标签选择器过滤指定的标签
  * 标签选择器目前有两个：基于等值关系（等于、不等于）和基于集合关系（属于、不属于、存在）
  * 许多资源支持内嵌标签选择器字段
    * matchLabels
    * matchExpressions
* Service:
  * 在k8s的世界里，虽然每个Pod都会被分配一个单独的ip地址，但这个ip地址会随着Pod的销毁而消失
  * Service（服务）就是用来解决这个问题的核心概念
  * 一个Service可以看作一组提供相同服务的Pod的对外访问接口
  * Service作用于哪些pod是通过标签选择器来定义的
* Ingress：
  * Ingress是k8s集群里工作在OSI网络参考模型下，第7层的应用，对外暴露的接口
  * Service只能进行L4流量调度，表现形式是ip+port
  * Ingress则可以调度不同业务域，不同URL访问路径的业务流量



##### 核心组件：
* 配置存储中心 -> etcd服务
* 主控（master）节点
    *  kube-apiserver服务
    *  kube-controller-manager服务
    *  kube-scheduler服务
* 远算（node）节点
    *  kube-kubelet服务
    *  kube-proxy服务
* CLI客户端
    * kubectl
* 核心附件
    * CNI网络插件 -> flannel/calico
    * 服务发现用插件 —>coredns
    * 服务暴露用插件 -> traefik
    * GUI管理插件 -> Dashboard