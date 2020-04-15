[TOC]



#### docker image 镜像操作

* docker image ls  查看镜像
* docker pull 拉取镜像



#### docker image ls 查看镜像

#### docker pull 查看镜像

#### docker image ls —filter dangling=true   查看虚悬镜像，即没有标签的镜像

###### 虚悬镜像出现的原因是当构建一个新镜像的时候，发现已经有镜像包含相同的标签，docker会移出旧镜像上的标签，将该标签在新镜像上



#### container容器文件

```markdown
docker container ls  #查看当前运行的容器
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
649a6b785a86        ubuntu              "bash"              3 seconds ago       Up 4 seconds    
————————————————
docker container kill 649a6b785a86 #杀死某个容器
```



#### docker inspect mysql

> docker 查看mysql的镜像的ip地址：
>
> IPAddress就是mysql的ip地址：
>
> `"IPAddress":"172.17.0.3"`





