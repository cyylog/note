[TOC]

#### Docker-Compose文件

compose文件使用yml格式，docker规定了一些指令，使用它们可以去设置对应的东西，主要分为了四个区域：

 * version：用于指定当前docker-compose.yml语法遵循哪个版本
 * services：服务，在它下面可以定义应用需要的一些服务，每个服务都有自己的名字、使用的镜像、挂载的数据卷、所属的网络、依赖哪些其他服务等等。
 * networks：应用的网络，在它下面可以定义应用的名字、使用的网络类型等
 * volumes：数据卷，在它下面可以定义数据卷，然后挂载到不同的服务下去使用。



##### 1.version语法：

用于指定当前compose文件语法遵循哪个版本



##### 2.services:

定义docker-compose管理的服务，包括服务的名称、使用的镜像、挂载的数据卷、所属的网络、依赖等等

[root@docker-server3 docker-compose]# vi docker-compose.yml 

```yaml
version: '3'
services:
	#docker run -d --name docker-compose_httpd-test_1 httpd:2.4
	httpd-test:
		image: httpd:2.4
	#docker run -d --name docker-compose_httpd_test2_1 -v /data:/var/www/html -p 80:80 httpd:2.4
	httpd-test-2:
		image: httpd:2.4
		volumes:
			- "/data:/var/www/html"
		ports:
			- "80:80"
	#docker run -d --name docker-compose_httpd-test-3_1 -v /data:/user/local/apache2/htdocs:rw -p 8080:80 httpd:2.4
	http-test-3:
		image: httpd:2.4
		volumes:
			- "/data:/usr/local/apache2/htdocs:rw"
		ports:
			- "8080:80"
	
```

第一行缩进就是容器的名字，但是在启动后，docker-compose会自动添加信息作为容器的名字

image:就是镜像的名字

容器再docker-compose都是后台运行的



##### 3.volumes

自定义数据卷

下面的 - 表示可以跟多个

```yaml
version: '3'
services:
	httpd-test-2:
	volumes:
		- "/data:/var/www/html"
		- "/etc/localtime:/etc/localtime"
	ports:
		- "80:80"
		- "2222:22"
```

docker的命令：docker run -d —name docker-compose_httpd-test-2_1 -v /data:/var/www/html -v /etc/localtime:/etc/localtime -p 2222:22 -p 80:80 httpd:2.4

volumes,可以不指定挂载路径，则会把路径挂载在本地的默认路径下使用diver：local



##### 4.environment

相当于-e传参数

```yaml
version: '3'
services:
  httpd-test:
    image: httpd:2.4
  httpd-test-2:
    image: httpd:2.4
    volumes:
      - "/data:/var/www/html"
      - "/etc/localtime:/etc/localtime"
    ports:
      - "80:80"
      - "2222:22"
  httpd-test-3:
    image: httpd:2.4
    volumes:
      - "/data:/usr/local/apache2/htdocs:rw"
    ports:
      - "8080:80"
    environment:
      index: "test"
```

##### 5.networks

网络决定了服务之间和外界如何去通信，在执行docker-compose up的时候，docker会默认创建一个默认网络，创建的服务也会默认的使用这个默认网络。服务和服务之间，可以使用服务的名字进行通信，也可以自己创建网络，并将服务加入到这个网络之中，这样服务之间可以相互通信，而外界不能够与这个网络中的服务通信，可以保持隔离性。