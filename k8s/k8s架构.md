





![image-20210910141248037](/Users/zhang/drzhang/demo/note/k8s/image-20210910141248037.png)



#### Control Plane（控制平面）：

* API server：apisever的核心功能是对核心对象（例如：Pod、Service、Deployment）的增删改查操作，同时也是集群内模块之间数据交换的枢纽。
* etcd：etcd用来保存所有的集群数据信息。
* scheduler：负责监视新创建的、未指定运行节点（node）的Pods，按照预定的调度策略将Pod调度到合适的Node上。
* controller-manager：负责维护集群的状态，比如故障检测、自动扩展、滚动更新等。
  * 节点控制器（Node Controller）：负责在节点出现故障时进行通知和响应
  * 任务控制器（Job Controller）： 监测代表一次性任务的Job对象，然后创建Pods来运行这些任务直到完成
  * 端点控制器（Endpoints Controller）：填充端点对象（即加入 Service 与 Pod）
  * 服务账户和令牌控制器（Service Account & Token Controllers）：为新的命名空间创建默认账户和API访问令牌

#### Node：

* kubelet：负责维护容器的生命周期，同时也负责Volume和网络的管理。
* kubeproxy：负责为 Service 提供 cluster内部的服务发现和负载均衡。



<img src="/Users/zhang/drzhang/demo/note/k8s/image-20210910135901027.png" alt="image-20210910135901027" style="zoom: 200%;" />







​	



#### Pod创建过程：



![](/Users/zhang/drzhang/demo/note/k8s/image-20210914160450942.png)



1. 用户通过 kubectl 或其他 API 客户端提交 Pod Spec 给 API Server。

2. API Server 将 Pod 对象的相关信息存入 etcd 中，待写入操作执行完成，API Server 即会返回确认信息至客户端。

3. 所有的 Kubernetes 组件均使用 watch 机制来跟踪检查 API Server 上的相关的变动。
4. kube-scheduler 通过 watch 觉察到 API Server 创建了新的 Pod 对象但尚未绑定至任何工作节点。
5. kube-scheduler 通过调度算法为 Pod 对象挑选一个工作节点并将结果信息更新至 API Server。
6. API Server将调度结果信息更新至 etcd 中，而且 API Server 也开始返回此 Pod 的调度结果。
7. Pod 被调度到目标工作节点上的 kubelet 尝试在当前节点上调用 Docker 启动容器，并将容器的结果状态回送值 API Server。
8. API Server 将 Pod 状态信息存入 etcd 系统中。
9. 在 etcd 确认写入操作完成后，API Server 将确认信息发送至相关的 kubelet，事件将通过它被接受。