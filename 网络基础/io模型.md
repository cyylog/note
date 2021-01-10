#### I/O模型

（1）同步阻塞IO（Blocking IO）：即传统的IO模型。

（2）同步非阻塞IO

（3）IO多路复用（IO Multiplexing）



##### 同步阻塞

![image-20210110165735896](/Users/drzhang/Library/Application Support/typora-user-images/image-20210110165735896.png)

用户发起read IO读操作，由用户空间转到内核空间。内核等到数据包到达后，然后将接收的数据拷贝到用户空间，完成read操作。

用户需要等待read将socket中的数据读取到buffer后，才继续处理接收的数据。整个IO请求的过程中，用户线程是被阻塞的，这导致用户在发起IO请求时，不能做任何事情，对CPU的资源利用率不够。



##### 2.同步非阻塞

![image-20210110170036462](/Users/drzhang/Library/Application Support/typora-user-images/image-20210110170036462.png)

用户线程发起IO请求时立即返回。但并未读取到任何数据，用户线程需要不断地发起IO请求，直到数据到达后，才真正读取到数据，继续执行。

用户需要不断地调用read，尝试读取socket中的数据，直到读取成功后，才继续处理接收的数据。整个IO请求的过程中，虽然用户线程每次发起IO请求后可以立即返回，但是为了等到数据，仍需要不断地轮询、重复请求，消耗了大量的CPU的资源。



##### 3.I/O多路复用

![image-20210110170510750](/Users/drzhang/Library/Application Support/typora-user-images/image-20210110170510750.png)

用户在发起请求建立起socket，首先将需要进行IO操作的socket添加到事件驱动模型中，然后等待驱动模型系统调用返回。当数据到达时，socket被激活，驱动模型函数返回。用户线程正式发起read请求，读取数据并继续执行。

但是，使用函数以后最大的优势是可以在一个线程内同时处理多个socket的IO请求。用户可以注册多个socket，然后不断地调用驱动模型读取被激活的socket，即可达到在同一个线程内同时处理多个IO请求的目的。

在同一个线程里面，通过拨开关的方式，来同时传输多个I/O流。

![image-20210110170905340](/Users/drzhang/Library/Application Support/typora-user-images/image-20210110170905340.png)

