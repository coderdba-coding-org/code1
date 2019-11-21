ansible-playbook --private-key=~/.ssh/myansible-priv -i inv/site1.inv --vault-password-file=~/.ssh/ansible_vault_pass -u root -e "full_reroll=yes" deploy_mycode.yml --limit 110.92.217.19
