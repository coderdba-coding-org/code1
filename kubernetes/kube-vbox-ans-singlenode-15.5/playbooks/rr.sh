#ansible-playbook -i ~/mywork2/kube-vbox-singlenode-1/ansible/inv/ksn2.inv remote1.yml
#ansible-playbook -i ../inv/ksn2.inv remote1.yml

#ansible-playbook -i ../inv/ksn2.inv remote1.yml --extra-vars "ansible_sudo_pass=root"
#ansible-playbook -i ../inv/ksn2.inv remote1.yml --extra-vars "ansible_password=root"
ansible-playbook -i ../inv/ksn2.inv remote1.yml -u root --private-key=~/.ssh/myansible.priv

