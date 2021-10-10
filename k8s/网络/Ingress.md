#### Ingress

Ingress公开了从集群外部到集群内services的HTTP和HTTPS路由。流量路由由Ingress资源上定义的规则控制。

> 必须具有Ingress控制器才能满足Ingress的要求。仅创建Ingress资源无效。



#### 创建Ingress对外路由步骤

1. 创建完pod后
2. 创建出service能够绑定到pod，然后可以先通过集群地址加svc的port请求看能否请求成功
3. 创建ingress关联到pod和svc
4. 在本机电脑配置集群地址和ingress里的hosts的映射
5. 可以在本机通过ingress的host加svc的port进行访问
6. 在Pod的containerPort下面加上hostPort可以直接通过ingress的host进行访问
