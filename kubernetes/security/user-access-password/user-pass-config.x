apiVersion: v1
clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: https://192.168.8.11
  name: scratch
contexts:
- context:
    cluster: scratch
    namespace: default
    user: devuser1
  name: scratch-default-ns
- context:
    cluster: scratch
    namespace: kube-system
    user: devuser2
  name: scratch-kube-system-ns
current-context: scratch-kube-system-ns
kind: Config
preferences: {}
users:
- name: developers
  user:
    password: devuser2pass
    username: devuser2
