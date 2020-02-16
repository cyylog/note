##### 消息系统介绍：

###### # 一个消息系统负责将数据从一个应用传递到另一个应用，应用只需关注于数据，无需关注数据在两个或多个应用间是如何传递的。分布式消息传递基于可靠的消息队列，在客户端应用和消息系统之间异步传递消息。有两种主要的消息传递模式：点对点传递模式、发布-订阅模式。kafka就是一种发布-订阅模式。



##### kafka中设计的名词：

![image-20191217111654363](/Users/drzhang/Library/Application Support/typora-user-images/image-20191217111654363.png)



##### broker(一台kafka服务器称为一个broker)

* kafka集群包含一个或多个服务器，服务器节点成为broker。
* broker存储topic的数据。如果某topic有N个partiton，集群有N个broker，那么每个broker存储该topic的一个partition。
* 如果某topic有N个partition，集群有(N+M)个broker，那么其中有N个broker存储该topic的一个partition，剩下的M个broker不存储该topic的partition数据。
* 如果某topic有N个partition，集群中broker数目少于N个，那么一个broker存储该topic的一个或多个pritition。在实际生产环境中，尽量避免这种情况的发送，这种情况容易导致kafka集群数据不均衡。

##### Topic

* 每条发布到kafka集群的消息都有一个类别，这个类别被称为topic。（物理上不同topic的消息分开存储，逻辑上一个topic的消息虽然保存于一个或多个broker上，但用户只需指定消息的topic即可生产或消费数据而不必关系数据存于何处）
* 类似于数据库的表名

#####partition

* topic中的数据分割为一个或多个partition。每个topic至少有一个partition。每个partition中的数据使用多个segment文件存储。
* partition中的数据是有序的，不同partition间的数据丢失了数据的顺序。如果topic有多个partition，消费数据时就不能保证数据的顺序。在需要严格保证数据的消费顺序的场景下，需要将partition的数目设为1.

##### producer

* 生产者即数据的发布者，该角色将消息发布到kafka的topic中。broker接收到生产者发送的消息后，broker将该消息追加到当前用于追加数据的segment文件中。生产者发送的消息，存储到一个partition中，生产者也可以指定数据存储到partition。

##### consumer

* 消费者可以从broker中读取数据。消费者可以消费多个topic中的数据。

##### consumer group

* 每个consumer属于一个特定的consumer group（可为每个consumer指定group name，若不指定group name则属于默认的group）。

##### leader

* 每个partition有多个副本，其中有且仅有一个作为leder，leader是当前负责数据的读写的partition。

##### follower

* follower跟随leader路由，数据变更会广播给所有follower，follower与leader保持同步。如果leader失效，则从follower中选举出一个新的leader。当follower与leader挂掉、卡住或者同步太慢，leader会把这个follower从ISR列表中删除，重新创建一个follower。



##### kafka使用场景

kafka的应用很广泛，在这里简单介绍几种

- 服务解耦

  比如我们发了一个帖子，除了写入数据库之外还有很多联动操作，比如给关注这个用户的人发送通知，推送到首页的时间线列表，如果用代码实现的话，发帖服务就要调用通知服务，时间线服务，这样的耦合很大，并且如果增加一个功能依赖发帖，除了要增加新功能外还要修改发帖代码。

  解决方法：引入kafka，将发完贴的消息放入kafka消息队列中，对这个主题感兴趣的功能就自己去消费这个消息，那么发帖功能就能够完全独立。同时即使发帖进程挂了，其他功能还能够使用，这样可以将bug隔离在最小范围内

- 流量削峰

流量削峰在消息队列中也是常用场景，一般在秒杀或团购活动中使用比较广泛。当流量太大的时候达到服务器瓶颈的时候可以将事件放在kafka中，下游服务器当接收到消息的时候自己去消费，有效防止服务器被挤垮

- 消息通讯

消息队列一般都内置了高效的通信机制，因此也可以用在纯的消息通讯中，比如客户端A跟客户端B都使用同一队列进行消息通讯，客户端A，客户端B，客户端N都订阅了同一个主题进行消息发布和接受不了实现类似聊天室效果





### kafka执行流程

![image-20200216220039671](/Users/drzhang/Library/Application Support/typora-user-images/image-20200216220039671.png)

1.生产者从kafka集群获取分区leader信息

2.生产者将消息发送给leader

3.leader将消息写入本地磁盘

4.follower从leader拉取消息数据

5.follower将消息写入本地磁盘后向leader发送ACK

6.leader收到所有的follower的ACK之后向生产者发送ACK