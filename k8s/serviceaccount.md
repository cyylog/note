#### ServiceAccount

##### serviceaccount是为了方便Pod里面的进程调用kubernetes API或其他外部服务而设计的。与user account 不通：

* user account是为人设计的，而service account 则是为Pod中的进程调用 kubernetes API而设计的；
* user account是跨 namespace 的，而 service account 则是只局限在它所在的namespace
* 每个namespace都会自动创建一个default service account；
* Token Controller 检测 service account 的创建，并为它们创建secret
* 开启ServiceAccount Admission Controller后：
  * 每个Pod在创建后都会自动设置spec.serviceAccount 为default（除非指定了其他的ServiceAccount）
  * 验证Pod引用的 service account 已经存在，否则拒绝创建
  * 如果Pod 没有指定 ImagePullSecrets，则把 service account 的 ImagePullSecrets加到Pod中
  * 每个container启动后都会挂载该service account的token 和 ca.crt 到 /var/run/secrets/kubernetes.io/serviceaccount/