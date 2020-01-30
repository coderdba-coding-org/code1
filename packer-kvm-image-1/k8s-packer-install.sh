#!/bin/bash -eux

setenforce 0

# Increase number of open file descriptors ugh
echo "fs.file-max=791577" >> /etc/sysctl.conf
echo "fs.inotify.max_user_instances=8192" >> /etc/sysctl.conf
echo "net.ipv4.conf.eth0.rp_filter = 2" >> /etc/sysctl.conf
echo "net.ipv4.conf.eth1.rp_filter = 2" >> /etc/sysctl.conf
echo "* soft nofile 791577" >> /etc/security/limits.conf
echo "* hard nofile 791577" >> /etc/security/limits.conf
sysctl -w kernel.pid_max=4194303
sysctl -p

cp /tmp/tgtcerts/* /etc/pki/ca-trust/source/anchors
update-ca-trust

rm /etc/yum.repos.d/*
/bin/cp -v /tmp/repos/*.repo /etc/yum.repos.d/

yum update --exclude=kernel*
yum install epel-release iftop sysstat htop -y
yum -y install cloud-init nfs-utils libnfsidmap install docker-ce-18.09.5-3.el7.x86_64 docker-ce-cli-18.09.5-3.el7.x86_64 kubelet-1.15.9-0.x86_64 kubectl-1.15.9-0.x86_64 kubernetes-cni-0.7.5-0.x86_64 nc ntp wget rsync
rm -f /etc/yum.repos.d/docker-ce.repo /etc/yum.repos.d/kubernetes.repo

/bin/cp /tmp/docker.service /usr/lib/systemd/system/docker.service

/bin/cp -R /tmp/etc/* /etc
/bin/cp -R /tmp/opt/* /opt

chmod +x /opt/k8s/k8s_cloud_init.sh
chmod +x /opt/k8s/k8_bootstrap.sh
chmod +x /opt/k8s/etcd-health.sh

cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep -v HWADDR >/tmp/foo
mv /tmp/foo /etc/sysconfig/network-scripts/ifcfg-eth0

chkconfig network on
service network start
systemctl enable docker && systemctl start docker

systemctl enable ntpd

systemctl enable mounter.timer

systemctl stop NetworkManager
systemctl disable NetworkManager

/bin/cp -R /tmp/home/* /home

mv /etc/docker/daemon.json{,.bk}
cat <<EOF > /etc/docker/daemon.json
{
  "registry-mirrors": ["https://docker.company.com:443"],
  "insecure-registries": ["docker.company.com:443"],
  "max-concurrent-downloads": 10
}
EOF
systemctl restart docker
# Ensure docker is running before going forward
while ! docker ps; do sleep 1; done

# Pull kubernetes images
docker pull etcd:v3.3.18
docker pull pause-amd64:3.1
docker pull kube-apiserver-amd64:v1.15.9
docker pull kube-scheduler-amd64:v1.15.9
docker pull kube-controller-manager-amd64:v1.15.9
docker pull kube-proxy-amd64:v1.15.9
docker pull flannel:v0.9.0-amd64

docker pull kube-dns-amd64:1.14.7
docker pull kube-dns-sidecar-amd64:1.14.7
docker pull kube-dns-dnsmasq-nanny-amd64:1.14.7

# Pull other images
docker pull my.repo.com/myimage:myversion

mv /etc/docker/daemon.json{.bk,}
systemctl stop docker

# When VM starts a new mountpoint creates at /var/lib/docker and images will be moved into it from /tmp/docker
mv /var/lib/docker /var/lib/docker-tmp
systemctl start docker

#cleanup
yum clean all
rm -rf /tmp/*
history -c
