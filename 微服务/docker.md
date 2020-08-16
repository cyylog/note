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

`docker container ls -f "status=exited" -q` #查看所有状态为关闭的container的id

`docker rm $(docker container ls -f "status=exited" -q)` #删除所有的状态为exited的container

## Dockerfile

- FROM：文件的开始
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
- ENV：设置变量
  - ENV MYSQL_VERISON=5.6 #设置常量
  - `RUN apt-get -y install mysql-server="${MYSQL_VERSION}"`
- CMD and ENTRYPOINT：
  - 若docker指定了其他命令，CMD会被忽略
  - 若定义多个CMD，只会执行最后一个CMD







##### docker操作etcd

```
docker run -d --name etcdclient -p 2379:2379 -e ALLOW_NONE_AUTHENTICATION=yes etcd:lastest
```

