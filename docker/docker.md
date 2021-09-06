[TOC]

### docker

#### docker image 镜像操作

- docker image ls 查看镜像
- docker pull 拉取镜像



#### docker虚浮镜像
查看虚浮镜像：`docker image ls --filter dangling=true`

删除全部的虚浮镜像：`docker rmi -f $(docker images --filter dangling=true -q)`

###### 虚悬镜像出现的原因是当构建一个新镜像的时候，发现已经有镜像包含相同的标签，docker会移出旧镜像上的标签，将该标签在新镜像上

#### container容器文件

```
docker container ls  #查看当前运行的容器
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
649a6b785a86        ubuntu              "bash"              3 seconds ago       Up 4 seconds    
————————————————
docker container kill 649a6b785a86 #杀死某个容器
```

docker container rm 'container id' #删除指定id的容器

```
docker container ls -q #查看正在运行container的id
```

`docker container ls -qa`#查看所有container的id

`docker rm $(docker container ls -qa)` #删除所有的container

`docker rm -f $(docker ps -a -q)` 删除所有的容器

`docker container ls -f "status=exited" -q` #查看所有状态为关闭的container的id

`docker rm $(docker container ls -f "status=exited" -q)` #删除所有的状态为exited的container

### docker常用命令
##### 镜像的常用命令：
```
docker image save
docker image rm == docker rmi
docker image load
docker image ls ==  docker images
docker image pull
docker search
```

##### 容器常用的命令
```
docker run 
docker stop
docker rm
docker ps 
docker exec 
docker kill
docker attach   ==离开终端ctrl+p,ctrl+q
docker commit
```

### Dockerfile

- FROM：指定基础镜像
  - FROM search：#从头开始制作一个最简的
  - FROM centos：#使用centos作为系统，若没有则拉取
  - FROM centos:7.0: #指定系统+版本号
- LABEL: 相当于注释或者说明
  - LABEL version="1.0"
  - LABEL author="zhang"

- RUN：用于执行后面跟着的命令
  - RUN 出现的次数越多，构建的层数也就越多，会造成镜像膨胀过大
  - 可以使用`&&`连接，这样只构建一层
  - eg：`RUN yum -y update && yum -y install lrzsz net-tools`
- WORKDIR：进入或创建目录
  - WORKDIR /root #进入/root目录
  - WORKDIR /test #创建/test目录
  - WORKDIR demo
  - RUN pwd # /test/demo
- ADD and COPY：将本地文件，添加到镜像里
  - ADD 可以解压缩文件
  - COPAY：复制指令，从上下文目录中复制文件或者目录到容器里指定路径。
  - ADD和COPY的区别就是，如果是压缩文件，ADD会解压文件，COPY只复制，不解压
- ENV：设置变量
  - ENV MYSQL_VERISON=5.6 #设置常量
  - `RUN apt-get -y install mysql-server="${MYSQL_VERSION}"`
  
- EXPOSE：指定对外的端口
  
  - -P  随机端口
- CMD ：指定容器启动后要干的事情
  - 若docker指定了其他命令，CMD会被忽略
  - 若定义多个CMD，只会执行最后一个CMD
- ENTRYPOINT：容器启动后执行的命令
  - 无法被替换，启动容器的时候执行的命令，会被当成参数
  
  

#### docker挂载
```
docker run -d -p 80:80 -p 81:81 -v /opt/test:/data -v /opt/test.conf:/etc/nginx/conf.d/test.conf nginx:latest
```

#### 创建数据卷
```
docker volume create my-vol
```

#### 查看数据卷
```
docker volume ls

```

#### 查看数据卷信息
```
docker volume inspect my-vol


[
    {
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my-vol/_data",
        "Name": "my-vol",
        "Options": {},
        "Scope": "local"
    }
]
```

#### 启动一个挂载数据卷的容器
```
 docker run -d -p \
    --name web \
    --mount source=my-vol,target=/webapp \
    training/webapp \
    python app.py
```

#### 查看数据卷的具体信息
``` 
docker inspect web

"Mounts": [
    {
        "Type": "volume",
        "Name": "my-vol",
        "Source": "/var/lib/docker/volumes/my-vol/_data",
        "Destination": "/app",
        "Driver": "local",
        "Mode": "",
        "RW": true,
        "Propagation": ""
    }
],
```
#### 删除数据卷
```
docker volume rm my-vol
```




#### docker启动mysql
```
docker run -d --restart always --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root mysql:5.7
```

>  m1版本docker镜像



#### docker操作etcd

```
docker pull 

docker run -d --restart always --name etcdclient -p 2379:2379 -e ALLOW_NONE_AUTHENTICATION=yes etcd:lastest
```

#### docker启动redis
```
docker run -d --restart always --name redis -p 6379:6379 redis:latest
```

#### docker启动elasticsearch
```
docker run -d --restart always --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e ES_JAVA_OPTS="-Xms64m -Xmx128m" elasticsearch:7.7.1
```

##### 附加：
```
es安转ik分词器：
docker exec -it elasticsearch /bin/bash

cd bin 
./elasticsearch-plugin install http://tomcat01.qfjava.cn:81/elasticsearch-analysis-ik-6.5.4.zip

docker restart elastricsearch
```


#### docker启动kibana
```
docker run -d --restart always --name kibana -p 5601:5601 --link elasticsearch(此处填es的容器名称或id) kibana:7.7.1

```

#### docker启动rabbitmq
```
docker run -d --name rabbitmq --hostname rabbitmq -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=admin -p 5672:5672 -p 15672:15672 f50f482879b3

```


#### docker启动zookeeper
```
 docker run -d --name zookeeper -p 2181:2181 -v /etc/localtime:/etc/localtime wurstmeister/zookeeper
```


#### docker启动kafka
```
docker run  -d --name kafka -p 9092:9092 -e KAFKA_BROKER_ID=0 -e KAFKA_ZOOKEEPER_CONNECT=47.103.9.218:2181 -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://47.103.9.218:9092 -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 -t wurstmeister/kafka
```



### docker设置CPU带宽
```
docker run --it --cpu-period=100000 --cpu-quota=20000 centos /bin/bash
```
> 在每100ms的时间里，这个docker容器只能使用到20%的CPU带宽



### 保存docker镜像和容器

#### 保存docker镜像

`docker save #ID or #Name`

> docker save方法，会保存该镜像的所有历史记录
>
> docker save保存的是镜像(image)



```shell
docker save [oprions] images [images...]

示例：
docker save -o nginx.tar ngixn:latest
或
docker save > nginx.tar nginx:latest
其中 -o 和 > 表示输出到文件，nginx.tar为目标文件，nginx:latest是源镜像名（name:tag）
```



#### 保存docker容器

`docker export #ID or #Name`

> docker export 方法不会保留历史记录，即没有commit历史
>
> docker export 保存的是容器（container）



```shell
docker export [options] container
示例：
docker export -o nginx-test.tar nginx-test
# 导出为tar
docker export #ID or #Name > /home/export.tar
其中 -o 表示输出到文件，nginx-test.tar为目标文件，nginx-test是源容器名（name）
```



#### 载入镜像包

`docker load`

> docker load 用来载入镜像包
>
> docker load 不能对载入的镜像重命名

```shell
docker load [options]
示例：
docker load -i nginx.tar
或
docker load < nginx.tar
其中 -i 和 < 表示从文件输入。会成功导入镜像及相关元数据，包括tag信息。
```



#### 载入容器包

`docker import`

> docker import 用来载入容器包，但是会恢复为镜像
>
> docker import 可以为镜像指定新名称



```shell
docker import [options] file|URL|- [REPOSITORY[:TAG]]
示例：
docker import nginx-test.tar nginx:imp
或
cat nginx-test.tar | docker import - nginx:imp
```



