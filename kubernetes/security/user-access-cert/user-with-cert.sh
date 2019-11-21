kubectl config --kubeconfig=user-cert-config set-cluster kubernetes-dev \
--server=https://192.168.8.11:6443 \
--certificate-authority=/etc/kubernetes/pki/ca.pem

kubectl config --kubeconfig=user-cert-config set-credentials user-for-kube-system \
--client-certificate=user-kubesystem.pem \
--client-key=user-kubesystem-key.pem \
--embed-certs=true

kubectl config --kubeconfig=user-cert-config set-context ns-kube-system \
--cluster=kubernetes-dev \
--namespace=kube-system \
--user=user-for-kube-system
