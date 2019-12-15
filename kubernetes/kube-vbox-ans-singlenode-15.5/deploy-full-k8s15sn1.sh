#ansible-playbook -u root --private-key=~/.ssh/myansible.priv -i inv/ksn2.inv deploy-full.yml
ansible-playbook -u root --private-key=~/.ssh/myansible.priv -i inv/k8s15sn1.inv deploy-full-k8s15sn1.yml
