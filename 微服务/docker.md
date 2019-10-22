[TOC]

### docker image 镜像操作

* docker image ls  查看镜像
* docker pull 拉取镜像



#### docker image ls 查看镜像

#### docker pull 查看镜像

#### docker image ls —filter dangling=true   查看虚悬镜像，即没有标签的镜像

###### 虚悬镜像出现的原因是当构建一个新镜像的时候，发现已经有镜像包含相同的标签，docker会移出旧镜像上的标签，将该标签在新镜像上



