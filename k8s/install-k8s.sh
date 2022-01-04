HOSTNAME=$1
MASTER=$2
NODE1=$3
NODE2=$4

cat  >> /etc/hosts << EOF
$MASTER master
$NODE1 node1
$NODE2 node2
EOF

hostnamectl set-hostname $HOSTNAME

### 禁用防火墙
systemctl stop firewalld
systemctl disable firewalld

### 禁用SEILINUX
setenforce 0


modprobe br_netfilter

cat >> /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF


sysctl -p /etc/sysctl.d/k8s.conf

### 安装ipvs
cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF


chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4

### 安装ipset软件包
yum -y install ipset

### 安装ipvsadm
yum -y install ipvsadm


### 同步服务器时间
yum install chrony -y


systemctl enable chronyd && systemctl start chronyd

chronyc sources

date

### 关闭swap分区
swapoff -a


### swappiness参数调整
cat >> /etc/sysctl.d/k8s.conf <<  EOF
vm.swappiness=0
EOF

sysctl -p /etc/sysctl.d/k8s.conf



### 安装docker
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo


yum -y install docker-ce-19.03.1


### 修改cgroup驱动
mkdir -p /etc/docker

cat >> /etc/docker/daemon.json << EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

### 启动docker
systemctl start docker && systemctl enable docker


### 指定yum源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


### 安装kubeadm、kubelet、kubectl
yum install -y kubelet-1.20.1 kubeadm-1.20.1 kubectl-1.20.1 --disableexcludes=kubernetes


### 设置开机启动
systemctl enable --now kubelet

