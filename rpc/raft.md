### raft原理：

架构

每个节点都包含状态机，日志模块和一致性模块。功能分别是：

* 状态机：数据一致性指的即是状态机的一致性，从内部服务看表现为状态机中的数据都保持一致
* log模块：保存了所有的操作记录
* 一致性模块：**一致性模块算法保证写入log命令的一致性，是raft的核心内容**

实现一致性的过程可分为：**Leader选举(Leader election)，日志同步(Log replication)，安全性(safty),**

**日志压缩(Log compaction)，成员变更(membership change)**



#### leader选举：

###### 注：Follower：初始状态节点，Candidate：候选人节点，Leader：leader节点

###### 竞选过程

* 节点由Follower变为Candidate，同时设置当前Term
* Candidate给自己投票，带上termid和日志序号，同时向其他节点发送拉票请求
* 等待结果，成为Leader，follower或者在选举未成为产生结果的情况下节点状态保持为Candidate

###### 选举结果：

1.成功当选收到超过半数的选票时，成为Leader，定时给其他节点发送心跳，并带上任期id，其他节点发现当前的任期id小于接收到leader发送过来的id，则将状态切换至follower

2.选举失败在Candidate状态接收到其他节点发送的信息且心跳中的任期id大于自己，则变为follower

3.未产生结果没有一个Candidate所获得的选票超过半数，未产生leader，则Candidate再进入下一轮投票。为了避免长期没有leader产生，raft采用如下策略避免：

* 选举超时时间为随机值，第一个超时的节点带着最大的任期id立刻进入新一任的选举
* 如果存在多个Candidate同时竞选的情况，发送拉票请求也是一段随机延时



#### 日志同步(Log Replication)：

流程：

>Leader选出后接收客户端的请求，leader把请求日志作为日志条目加入到日志中，然后向其他follower节点复制日志，当超过半数的follower确认接收到复制的日志时，则leader将日志应用到状态机并向客户端返回执行结果，同时follower也将结果提交。
>
>如果存在follower没有成功复制日志，leader则会无限重试

###### 日志同步的关键点:

* 日志由有序编号的日志条目组成，每条日志包含创建的任期和用于执行 的命令，日志是保证所有节点数据一致的关键。
* leader负责一致性检查，同时让所有的follower都和自己保持一致。
* 在leader发生切换时，如何保证各节点日志一致？leader为每一个follower维护一个nextIndex，将index和tremid信息发生至follower，从缺失的tremid和index为follower补齐数据，直至和leader完全一致
* 只允许主节点提交包含当前term的日志。否则会出现已经commit的日志出现更改的情况



#### 安全性：

安全性的原则是一个term只有一个leader，被提交至状态机的数据不能发生更改。保证安全性主要通过限制leader的选举来保证：

* Candidate在拉票时需要携带本地已持久化的最新的日志信息，如果投票节点发现本地的日志信息比Candidate更新，则拒绝投票。
* 只允许leader提交当前term的日志。
* 拥有最新的已提交的log entry的follower才有资格成为leader











## Raft leader选举

#### 1.心跳机制触发leader选举

##### 当leader选举成功后，会通过心跳机制来维持自己的权威

1.leader周期性的向所有跟随者发送心跳包维持自己的权威

2.如果一个leader在一段时间里，没有收到任何消息，称为选举超时，这时会认为没有可用的leader，重新进行leader的选举





## Raft协议safefy安全性









