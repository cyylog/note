[toc]

#### linux权限设置
|权限符号|权限意思|
|--|--|
|r|可读|
|w|可写|
|x|可执行|
```json
chmod u=rwx,g=rx,o=r test.sh

u指user，g指group，o指other


chmod a+w test.sh		--所有用户增加write权限

chmod a-x test.sh		--所有用户去除执行权限
```


#### df
```json
df -a 	列出所有的档案系统，包括系统特有的 /proc 等档案系统
df -k		以 KBytes 的容量显示各档案系统
df -m		以 MBytes 的容量显示各档案系统
df -h		以人们较易阅读的 GBytes, MBytes, KBytes 等格式自行显示
df -H 	以 M=1000K 取代 M=1024K 的进位方式
df -T		连同该 partition 的 filesystem 名称 (例如 ext3) 也列出
df -i		不用硬盘容量，而以 inode 的数量来显示
```


#### vi
##### vi常用快捷命令
| 快捷键 | 操作|
| --| --|
| ctrl + f | 向下移动一页 |
|ctrl + b | 向上移动一页|
|ctrl + d | 向下移动半页|
|ctrl + u | 向上移动半页|
| +  | 移动到非空格符的下一列|
|- | 移动到非空格符的上一列|
| n<space> | n表示数字，按下数字后再按空格键，光标会向右移动这一行的n个字符。|
| 0 | 移动到这一行的最前面字符处|
| $ | 移动到这一行的最后面字符处 |
| H | 光标移动到这个屏幕的最上方那一行 |
| M | 光标移动到这个屏幕中央那一行 |
| L |  光标移动到这个屏幕最下方那一行 |
|G | 移动到这个档案的最后一行 |
| nG | 移动到第n行 |
| gg | 移动到文档第一行 |


#### kill
```shell
kill pid	#终止进程

kill -STOP pid	#暂停进程

kill -CONT pid	#继续执行进程
```



#### PS

ps命令输出中的STAT一列用来表明进程的当前状态。
| STAT代码 | 说明|
| -- | -- |
|S | 睡眠。通常是在等待某个时间的发生，如一个信号或有输入可用|
| R | 运行。严格来说，应是”可运行“，即在运行队列中，处于正在执行或即将运行状态|
| D | 不可中断的睡眠（等待）。通常是在等待输入或输出完成。|
| T | 停止。通常是被shell作业控制所停止，或者进程正处于调试器的控制下 |
| Z	|	死(Defunct)进程或僵尸(zombie)进程	|
| N	|	低优先级任务。 |
| w | 分页。 |
| s | 进程是会话期首进程 |
| + | 进程属于前台进程组 |
| l | 进程是多线程的 |
| < | 高优先级任务 |




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


> **进程对每种信号的处理，包括上面三个选择：调用系统缺省行为、捕获、忽略。**

```json
第一个选择就是缺省，如果我们在代码中对某个信号，比如SIGTERM信号，不做任何 signal() 相关的系统调用，那么在进程运行的时候，如果接受到信号 SIGTERM，进程就会执行内核中 SIGTERM 信号的缺省代码。

内核中对不同的信号有不同的缺省行为，一般会采用退出（terminate），暂停（stop），忽略（ignore）这三种行为中的一种。
对于 SIGTERM 这个信号来说，它的缺省行为就是进程退出（terminate）。


第二个选择捕获，捕获指的就是我们在代码中为某个信号，调用 signal() 注册自己的handler。这样进程在运行的时候，一旦接受到信号，就不会再去执行内核中的缺省代码，而是会执行通过 signal() 注册的handler。


第三个选择忽略，如果要让进程“忽略”一个信号，我们就要通过 signal() 这个系统调用，为这个信号注册一个特殊的handler，也就是 SIG_IGN.
```

> **SIGKILL 和 SIGSTOP 信号是两个特权信号，它们不可以被捕获和忽略，这个特点也反映在 signal() 上**







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



#### linux限制进程数目

```json
一台linux机器上的进程总数目是有限制的。如果超过这个最大值，那么系统就无法创建出新的进程了，比如你想 SSH 登录到这台机器上就不行了。
可以通过 /proc/sys/kernel/pid_max 参数看到最大值。

Linux 内核在初始化系统的时候，会根据机器 CPU 的数目来设置 pid_max 的值。

比如说，如果机器中 CPU 数目小于等于 32，那么 pid_max 就会被设置为 32768(32K);如果机器中的 CPU 数目大于 32，那么 pid_max 就被设置为 N*1204 (N 就是 CPU 数目)。
```











