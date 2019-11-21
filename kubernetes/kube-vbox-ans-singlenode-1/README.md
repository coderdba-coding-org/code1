## FLANNEL - CAUTION  
If using flannel, then upon installing it,  
add the following line to 10-kubeadm.conf,   
reference KUBELET_NETWORK_ARGS in the ExecStart command in that config file,  
and, then restart kubelet,  
and, kill kube-dns and other such pods THAT HAVE DOCKER IP instead of CIDR IP   
  
Note: Change node-ip to the IP of the node  

Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin --node-ip=192.168.8.11"

ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS $KUBELET_NETWORK_ARGS $KUBELET_DNS_ARGS --client-ca-file=/etc/kubernetes/pki/ca.pem --tls-cert-file=/etc/kubernetes/pki/kubelet-192.168.10.101.pem --tls-private-key-file=/etc/kubernetes/pki/kubelet-192.168.8.11-key.pem --kubeconfig=/etc/kubernetes/kubeconfig.kubelet-192.168.8.11 --allow-privileged

