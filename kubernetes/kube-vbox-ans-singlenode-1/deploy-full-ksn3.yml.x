---
- hosts: all
  tasks:
    - name: Yum installs
      roles:
      - { role: yum }

    - name: Certificate generation
      roles:
      - { role: certs-gen }
    
    - name: Environment files
      roles:
      - { role: certs-copy }
    
    - name: Environment files
      roles:
      - { role: environment }
    
    - name: Etcd Service
      roles:
      - { role: etcd }
    
    - name: Manifests
      roles:
      - { role: manifests }
    
    - name: Kubelet config
      roles:
      - { role: kubelet }
  
    - name: kube-proxy
      roles:
      - { role: kube-proxy }
  
    - name: flannel 
      roles:
      - { role: flannel }
 
    - name: kube-dns 
      roles:
      - { role: kube-dns }
