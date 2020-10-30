# 
# KUBERNETES 15.5 ON CENTOS - ANSIBLE INSTALL
#

## STEPS

### Setup VM/machine

Follow document: https://github.com/coderdba/NOTES/blob/master/kubernetes-kb/kub-machines/k8s-model-vm.txt  
Scripts under: https://github.com/coderdba/NOTES/tree/master/kubernetes-kb/kub-machines/1.15.5  

Hostname: ksn5  
IP: 192.168.40.15  

If using Virtualbox - ensure virtualbox network exists for 192.168.40.X

### Ensure that /etc/hosts has the entry for the hostname and IP of the VM
```
[root@ksn5 ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
192.168.40.15 ksn5
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

### Add a public key to the VM
Generate a RSA key pair without passphrase  
Rename the files as follows for convenience:
Private key file: myansible.priv
Public key file: myansible.priv.pub  

Add contents of ~/.ssh/myansible.priv.pub (on laptop) to /root/.ssh/authorized_keys file
Test connection from your laptop to the VM:
```
ssh -i ./myansible.priv root@192.168.40.15
```

### Create inventory file
```
Example: inv/ksn5.inv
```
```
[all]
192.168.40.15

[etcd]
192.168.40.15

[master]
192.168.40.15

[worker]
192.168.40.15
```

### Create deploy yaml

Create deploy-full-ksn5.yml - copying contents of deploy-full-model.yaml

Comment out yum installs in deploy-full-ksn5.yml if those are already installed - when you had set up the VM

```
#- name: Yum installs
#  hosts: all
#  roles:
#  - { role: yum }
```
### Create deploy shell script

Create deploy-full-ksn5.sh using contents of deploy-full-model.sh - AND - reference the correct ksn5 yml file  
```
ansible-playbook -u root --private-key=~/.ssh/myansible.priv -i inv/ksn5.inv deploy-full-ksn5.yml
```
### Run the deploy shell script
```
./deploy-full-ksn5.sh  
```


## FLANNEL - CAUTION

If using Flannel, upon initial installation, it would be failing constantly:
```
[root@ksn5 ~]# kubectl get pods --all-namespaces
NAMESPACE     NAME                           READY   STATUS    RESTARTS   AGE
kube-system   kube-apiserver-ksn5            1/1     Running   0          4m53s
kube-system   kube-controller-manager-ksn5   1/1     Running   0          4m53s
kube-system   kube-dns-7c88ffc4c5-42fp5      2/3     Running   1          71s
kube-system   kube-flannel-ds-amd64-g9pcp    0/1     Error     1          76s
kube-system   kube-proxy-s28fs               1/1     Running   0          80s
kube-system   kube-scheduler-ksn5            1/1     Running   0          4m49s
```

Then, upon installing it (aka, upon completion of the ansible run)
add the following line to /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf  
- As in the line below referencing CNI items in KUBELET_NETWORK_ARGS
#### (Note: Change node-ip to the IP of the node)   
Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin --node-ip=192.168.40.15"  

- Ensure $NETWORK_ARGS is in ExecStart as follows:  
#### (Note: Change node-ip to the IP of the node)
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS $KUBELET_NETWORK_ARGS $KUBELET_DNS_ARGS --client-ca-file=/etc/kubernetes/pki/ca.pem --tls-cert-file=/etc/kubernetes/pki/kubelet-192.168.40.15.pem --tls-private-key-file=/etc/kubernetes/pki/kubelet-192.168.40.15-key.pem --kubeconfig=/etc/kubernetes/kubeconfig.kubelet-192.168.40.15 --allow-privileged  

- and, then restart kubelet
```
systemctl restart kubelet
```  

- and, kill kube-dns and other such pods THAT HAVE DOCKER IP instead of CIDR IP   
#### Pods with Docker IP:
```
[root@ksn5 ~]# kubectl get pods --all-namespaces -o wide
NAMESPACE     NAME                           READY   STATUS    RESTARTS   AGE     IP              NODE   NOMINATED NODE   READINESS GATES
kube-system   kube-apiserver-ksn5            1/1     Running   0          10m     192.168.40.15   ksn5   <none>           <none>
kube-system   kube-controller-manager-ksn5   1/1     Running   0          10m     192.168.40.15   ksn5   <none>           <none>
kube-system   kube-dns-7c88ffc4c5-42fp5      1/3     Error     10         6m40s   172.17.0.2      ksn5   <none>           <none>
kube-system   kube-flannel-ds-amd64-g9pcp    1/1     Running   8          6m45s   192.168.40.15   ksn5   <none>           <none>
kube-system   kube-proxy-s28fs               1/1     Running   0          6m49s   192.168.40.15   ksn5   <none>           <none>
kube-system   kube-scheduler-ksn5            1/1     Running   0          10m     192.168.40.15   ksn5   <none>           <none>
```

#### Now, kill kube-dns pod:
```
[root@ksn5 ~]# kubectl delete pod kube-dns-7c88ffc4c5-42fp5  -n kube-system
pod "kube-dns-7c88ffc4c5-42fp5" deleted
```

#### Verify
```
[root@ksn5 ~]# kubectl get pods --all-namespaces -o wide
NAMESPACE     NAME                           READY   STATUS    RESTARTS   AGE    IP              NODE   NOMINATED NODE   READINESS GATES
kube-system   kube-apiserver-ksn5            1/1     Running   1          24m    192.168.40.15   ksn5   <none>           <none>
kube-system   kube-controller-manager-ksn5   1/1     Running   1          24m    192.168.40.15   ksn5   <none>           <none>
kube-system   kube-dns-7c88ffc4c5-z8r5z      3/3     Running   0          9m2s   10.20.0.2       ksn5   <none>           <none>
kube-system   kube-flannel-ds-amd64-ntffx    1/1     Running   6          9m7s   192.168.40.15   ksn5   <none>           <none>
kube-system   kube-proxy-s28fs               1/1     Running   1          20m    192.168.40.15   ksn5   <none>           <none>
kube-system   kube-scheduler-ksn5            1/1     Running   1          24m    192.168.40.15   ksn5   <none>
```

## TROUBLESHOOTING

### Error with kubectl logs command
```
dial tcp: lookup ksn5 on 10.97.40.216:53: no such host
```

Fix:  Ensure entry for VM hostname and IP address in /etc/hosts
```
[root@ksn5 ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
192.168.40.15 ksn5
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```
