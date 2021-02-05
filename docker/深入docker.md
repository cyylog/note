[Toc]



### docker Namespace

```
Cgroup(control Groups)：可以对指定的进程做各种计算机资源的限制，比如限制CPU的使用率，内存使用量，IO设备的流量等等
 * CPU子系统，用来限制一个控制组（一组进程，可以理解为一个容器里的所有进程）可使用的最大CPU。
 * memory子系统，用来限制一个控制组最大的内存使用量。
 * pids子系统，用来限制一个控制组里最多可以运行多少个进程。
 * cpuset子系统，这个子系统用来限制一个控制组里的进程可以在哪几个物理CPU上运行。
```

```json
ipc
network
mount
pid
time
user
uts
```

##### PID Namespace

> 负责隔离不同容器的进程

##### Network Namespace

> 负责管理网络环境的隔离

##### Mount Namespace

> 管理文件系统的隔离 

```
PID
```

##### Namespace和Cgroups的区别

>   Namespace帮助容器来实现各种计算资源的隔离，Cgroups主要限制的是容器能够使用的某种资源量。

容器其实就是Namespace + Cgroups







##### 进程处理信号的三种选择

| --             | --                                               |
| -------------- | ------------------------------------------------ |
| 忽略（Ignore） | 对信号不做任何处理，但 SIGKILL 和 SIGSTOP 例外。 |
|捕获（Catch） | 让用户进程可以注册自己针对这个信号的handler，但 SIGKILL 和 SIGSTOP例外。|
| 缺省（Default） | Linux为每个信号都定义一个缺省的行为。|



