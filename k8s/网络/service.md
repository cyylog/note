#### Service

##### service出现的原因：

我们知道**Deployment可以动态的创建和销毁Pod**，**每个Pod都有自己的IP，但是如果重建了Pod，那么他的IP也就变化了**。这样会有一个问题：比如我们有一些后端的Pod集合为集群中的其他应用提供API服务，如果我们在前端应用中把所有的这些后端的 Pod 的地址都写死，然后以某种方式去访问其中一个 Pod 的服务，这样看上去是可以工作的，对吧？但是如果这个 Pod 挂掉了，然后重新启动起来了，是不是 IP 地址非常有可能就变了，这个时候前端就极大可能访问不到后端的服务了。

为解决这个问题 Kubernetes 就为我们提供了这样的一个对象 - Service，Service 是一种抽象的对象，它定义了一组 Pod 的逻辑集合和一个用于访问它们的策略，其实这个概念和微服务非常类似。一个 Serivce 下面包含的 Pod 集合是由 Label Selector 来决定的。

##### service的四种类型:

* ClusterIP：默认类型，自动分配一个仅cluster内部可以访问的虚拟ip
* NodePort：在ClusterIP基础上为service在每台机器上绑定一个端口，这样就可以通过NodeIP:Port方式来访问该服务
* Loadbalance：在NodePort基础上，接触cloud provider创建一个外部负载均衡器，并将请求转发到nodeip:port
* externalName：把集群外部的服务引入到集群内部，在集群内中直接使用，没有任何类型的代理被创建

