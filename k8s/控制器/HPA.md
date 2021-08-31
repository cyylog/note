### HPA控制器

在前面创建Deployment的时候，可以通过 `kubectl scale`   命令可以实现pod的扩缩容，但是这个命令只能手动操作，为了应对线上的复杂情况，来自动进行扩缩容，kubernetes提供了`Horizontal Pod Autoscaling（Pod水平自动伸缩）`，简称`HPA`