#### Pod

`pod`内部通过`cni`或者其他网络规则，生成对应的`ip`，一个`pod`内的所有容器共享这个`ip`



#### Service

`Service`通过ClusterIP或者`NodePortIP`方式，生成IP规则，`Service`通过定义`SelectorLabels`来绑定对应`labels``的Pods`，创建`Service`时，还会创建一`个Endpoint`资源，后续对`Pod`的变动都是修改这个`Endpoint`资源（`Endpoint`就是`service`关联的`pod`的`ip`和`端口`）



#### Ingress

`Ingress`用来提供对外访问服务，通过`Service`找到`Endpoint`里对应的 `PodIP`，拿到后添加到自己这里，所以`Ingress`实际绑定的是对应的提供对外服务的`PodIP`





> Service一般用来提供不同node之间的访问，负载多Pod；
>
> Ingress先通过访问svc中的Endpoint绑定的Poddeip，用来提供对外开放服务。