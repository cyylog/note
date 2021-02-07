[toc]





#### linux 1号进程

> 它是用户态的进程。它直接或者间接的创建了Namespace中的其他进程。

#### linux信号

> Linux有31个基本信号，进程在处理大部分信号时有三个选择。

##### 进程处理信号的三种选择

| --             | --                                               |
| -------------- | ------------------------------------------------ |
| 忽略（Ignore） | 对信号不做任何处理，但 SIGKILL 和 SIGSTOP 例外。 |
|捕获（Catch） | 让用户进程可以注册自己针对这个信号的handler，但 SIGKILL 和 SIGSTOP例外。|
| 缺省（Default） | Linux为每个信号都定义一个缺省的行为。对于大部分的信号，应用程序不需要注册自己的handler，使用系统缺省定义行为即可。 |



#### linux信号

##### linux特权信号

> 特权信号就是linux为kernel和超级用户去删除任意进程所保留的，不能被忽略也不能被捕获。

##### linux的特权信号：SIGKILL(9)、SIGSTOP

```json
运行命令 kill -9 1 里的参数`-9`，其实就是指发送编号为9的这个SIGKILL信号给 1 号进程。
```



```json
在Linux实现里，kill 命令调用了kill()的这个系统调用（所谓系统调用就是内核的调用接口）而进入到了内核函数 sys_kill()。
而内核在决定把信号发送给1号进程的时候，会调用sig_task_ignore()这个函数来做这个判断。它会决定内核在哪些情况下会把发送的这个信号给忽略掉。如果信号被忽略了，那么init进程就收不到指令了。
```

![image-20210205165126571](/Users/drzhang/Library/Application Support/typora-user-images/image-20210205165126571.png)













