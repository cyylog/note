#### CronJob

CronJobs对于创建周期性的、反复重复的任务很有用，例如执行数据备份或者发送邮件。

CronJobs也可以用来计划在指定时间来执行的独立任务，例如计划当集群看起来很空闲时执行某个Job。

> 为CronJob资源创建清单时，名称不能超过52个字符，这是因为CronJob控制器将自动提供的Job名称后附加11个字符，并且存在一个限制，即 Job 名称的最大长度不能超过63个字符。



##### CronJob的重启策略

Job 中 Pod 的 [`RestartPolicy`](https://kubernetes.io/zh/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy) 只能设置为 `Never（从不重启）` 或 `OnFailure（失败时重启）` 之一。



##### 限制任务的运行时间

Job任务对应的Pod在运行结束后，会变成`Completed`状态，同时可以在Job对象中通过设置字段`spec.activeDeadlineSeconds`来限制任务运行的最长时间。

```yaml
spec:
  activeDeadlineSeconds: 100		# 当我们的Pod任务运行超过100s后，这个Job的所有Pod都会被终止。
```

##### 限制Pod数量

可以通过设置`spec.parallelism`参数来进行并行控制，该参数定义一个Job在任意时间最多有多少个Pod同时运行。

`spec.completions`参数定义Job至少要完成的Pod数目。