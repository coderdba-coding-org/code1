# KUBERNETES 15.5 ON CENTOS - ANSIBLE installing

## STEPS

### Setup VM/machine

Follow document: https://github.com/coderdba/NOTES/blob/master/kubernetes-kb/kub-machines/k8s-model-vm.txt  
Scripts under: https://github.com/coderdba/NOTES/tree/master/kubernetes-kb/kub-machines/1.15.5  

Hostname: ksn5  
IP: 192.168.40.15  

If using Virtualbox - ensure virtualbox network exists for 192.168.40.X

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

## FLANNEL - CAUTION  
If using flannel, then upon installing it,  
add the following line to 10-kubeadm.conf,   

- As in the line below referencing CNI items in KUBELET_NETWORK_ARGS   
Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin --node-ip=192.168.8.11"  
(Note: Change node-ip to the IP of the node)  

- Ensure $NETWORK_ARGS is in ExecStart as follows:  
(Note: Change node-ip to the IP of the node)  
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS $KUBELET_NETWORK_ARGS $KUBELET_DNS_ARGS --client-ca-file=/etc/kubernetes/pki/ca.pem --tls-cert-file=/etc/kubernetes/pki/kubelet-192.168.10.101.pem --tls-private-key-file=/etc/kubernetes/pki/kubelet-192.168.8.11-key.pem --kubeconfig=/etc/kubernetes/kubeconfig.kubelet-192.168.8.11 --allow-privileged  

- and, then restart kubelet,  

- and, kill kube-dns and other such pods THAT HAVE DOCKER IP instead of CIDR IP   
