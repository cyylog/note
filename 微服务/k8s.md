[TOC]

##### k8s概念：



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