kubectl config --kubeconfig=user-pass-config set-cluster kubernetes-dev --server=https://192.168.8.11 --insecure-skip-tls-verify

kubectl config --kubeconfig=user-pass-config set-credentials developer --username=devuser1 --password=devuser1pass
kubectl config --kubeconfig=user-pass-config set-context scratch-default-ns --cluster=kubernetes-dev --namespace=default --user=developer

kubectl config --kubeconfig=user-pass-config set-credentials tester --username=devuser2 --password=devuser2pass
kubectl config --kubeconfig=user-pass-config set-context scratch-kube-system-ns --cluster=kubernetes-dev --namespace=kube-system --user=tester

#kubectl config --kubeconfig=user-pass-config view
#kubectl config --kubeconfig=user-pass-config use-context scratch-default-ns
#kubectl config --kubeconfig=user-pass-config view --minify

#kubectl config --kubeconfig=user-pass-config use-context scratch-kube-system-ns
#kubectl config --kubeconfig=user-pass-config view --minify
