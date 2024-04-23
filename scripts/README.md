Ansible Automation for VCF Tanzu Namespaces
==============
Overview
-----------
This repository can be used to deploy VCF Namespaces and associated nsxt/avi components using networks retrieved from infoblox.  

Contents
-----------
- [Overview](#overview)
- [Contents](#contents)
- [Install Dependencies](#install-dependencies)
- [Create Namespace](#create-namespace)
- [Remove Namespace](#remove-namespace)
- [Github Deploy Keys](#github-deploy-keys)
- [Ansible Vault](#ansible-vault)
- [References](#references)

Install Dependencies
-----------
First install the python dependencies via pip.  
`pip3 install -r requirements.txt`

Next install the ansible collections defined in requirements.yml with the command below.  
`ansible-galaxy collection install -r requirements.yml`


Create Namespace
-----------
The [tanzu_automation.yml](playbooks/tanzu_automation.yml) playbook is used to create new vSphere namespaces.
- Actions  
    - Check out the [VMWareTanzuAnsibleConfig](https://github.com/MSK-Staging/VMWareTanzuAnsibleConfig) repository.
    - Fetches the next available networks for egress, ingress, namespace, and avi load balancer networks from [infoblox](https://140.163.133.136/ui/).  Tasks are contained in [playbooks/tasks/manage_infoblox.yml](playbooks/tasks/manage_infoblox.yml).
    - Creates a VCF workload namespace using the egress, ingress, and namespace networks defined in [playbooks/tasks/manage_namespace.yml](playbooks/tasks/manage_namespace.yml)
    - Creates [NSX-T](https://vsmskpvcfwnsx.mskcc.org/nsx) components defined in [playbooks/tasks/create_nsxt_components.yml](playbooks/tasks/create_nsxt_components.yml)
    - Creates [AVI](https://avi-vcf-mon-tanzu-01.mskcc.org/) components defined in [playbooks/tasks/create_avi_components.yml](playbooks/tasks/create_nsxt_components.yml)
    - Sends an email to the requester via [Sendgrid](https://api.sendgrid.com) as defined in [playbooks/tasks/send_mail.yml](playbooks/tasks/send_mail.yml).
    - Write a namespace config file to the [VMWareTanzuAnsibleConfig](https://github.com/MSK-Staging/VMWareTanzuAnsibleConfig) repository using [playbooks/tasks/manage_namespace_config.yml](playbooks/tasks/manage_namespace_config.yml).
- Required parameters
    - itsm_request - service request used to track request
    - namespace_environment - environment from which to pull infoblox network from.  Valid values are 'prod' and 'nonprod'
    - namespace_name - name to use for the vsphere namespace
    - requester - name of the requester
    - requester_email -  email address for the requester
    - namespace_permissions - AD group that should have access to the namespace
    - backup_policy - placeholder for backup policy to be used for namespace
- Playbook CLI Execution: The example below is how to run the playbooks from a command line environment where ansible is installed.  The path to the vault key and the content will need to be updated to match the local environment.  The content of the file will need to be populated with the value that was used to encrypt playbook secret values.
    - `ansible-playbook playbooks/tanzu_automation.yml --e "itsm_request=sr_12345 requester_name='Joe Bond' requester_email='bondj@mskcc.org' namespace_environment=nonprod namespace_name=apm0001-t namespace_permissions=GRP_TDV_VCF_VMW_POC backup_policy=daily --vault-password-file ~/path/to/vault_key"`


Remove Namespace
-----------
The [cleanup_namespace.yml](playbooks/cleanup_namespace.yml) removes a namespace from vsphere and all associated components(avi, nsxt, infoblox).
- Actions  
    - Check out the [VMWareTanzuAnsibleConfig](https://github.com/MSK-Staging/VMWareTanzuAnsibleConfig) repository.
    - Load variables from the namespace config file located in the [VMWareTanzuAnsibleConfig](https://github.com/MSK-Staging/VMWareTanzuAnsibleConfig) repository.
    - Delete [AVI](https://avi-vcf-mon-tanzu-01.mskcc.org/) components defined in [playbooks/tasks/delete_avi_components.yml](playbooks/tasks/delete_nsxt_components.yml)
    - Delete [NSX-T](https://vsmskpvcfwnsx.mskcc.org/nsx) components defined in [playbooks/tasks/delete_nsxt_components.yml](playbooks/tasks/delete_nsxt_components.yml)
    - Delete a VCF workload namespace with [playbooks/tasks/manage_namespace.yml](playbooks/tasks/manage_namespace.yml)
    - Release  the infoblox networks found in the namespace config in [infoblox](https://140.163.133.136/ui/).  Tasks are contained in [playbooks/tasks/delete_network.yml](playbooks/tasks/delete_network.yml).
    - Sends an email to the requester via [Sendgrid](https://api.sendgrid.com) as defined in [playbooks/tasks/send_mail.yml](playbooks/tasks/send_mail.yml).
    - Remove the corresponding namespace config file located in the [VMWareTanzuAnsibleConfig](https://github.com/MSK-Staging/VMWareTanzuAnsibleConfig) repository using [playbooks/tasks/manage_namespace_config.yml](playbooks/tasks/manage_namespace_config.yml).
- Required parameters
    - itsm_request - service request used to track request
    - namespace_environment - environment from which to pull infoblox network from.  Valid values are 'prod' and 'nonprod'
    - namespace_name - name to use for the vsphere namespace
    - requester - name of the requester
    - requester_email -  email address for the requester
- Playbook CLI Execution: The example below is how to run the playbooks from a command line environment where ansible is installed.  The path to the vault key and the content will need to be updated to match the local environment.  The content of the file will need to be populated with the value that was used to encrypt playbook secret values.
    - `ansible-playbook playbooks/cleanup_namespace.yml --e "itsm_request=sr_12345 requester_name='Joe Bond' requester_email='bondj@mskcc.org' namespace_environment=nonprod namespace_name=apm0001-t --vault-password-file ~/path/to/vault_key"`


Github Deploy Keys
-----------
The Ansible Automation Platform(AAP) project uses a github deploy key to sync code between github and AAP.  A github deploy key is a public key defined inside of a github repository that can be used to access the repository and optionally write code to the repository.  The key labeled 'tanzu_automation_aap_key' in AAP is used to access this repository from AAP.  Below are the steps to regenerate the key.  

`ssh-keygen -t rsa -f ~/path/tanzu_automation_key -N ''`

This command generates a private key file named tanzu_automation_key and a public key file named tanzu_automation_key.pub.  The content of the private key file should be put into AAP as a source code credential.  The content of the public key should be added to the [github deploy key section](https://github.com/MSK-Staging/VMWareTanzu/settings/keys).  

In addition to a github deploy key for syncing code in AAP this code base uses a github deploy key defined in the [VMWareTanzuAnsibleConfig](https://github.com/MSK-Staging/VMWareTanzuAnsibleConfig) repository.  That key is used to check in configuration files for namespaces that have been created.  The [current private key](playbooks/files/git_deploy_key) is checked into this repository and encrypted with ansible vault.

Ansible Vault
-----------
The passwords and deploy keys used in this repository have been encrypted with [ansble-vault](https://docs.ansible.com/ansible/latest/vault_guide/vault_encrypting_content.html).  The vault password value that was used to encrypt the secrets should be stored in a safe place like cyberark or hashicorp vault.  If the value is lost the secrets must be encrypted with a new vault password value.  Below is an example of how to encrypt secrets with ansible vault.  

`ansible-vault encrypt_string "vmware6543!" --vault-password-file ~/.tanzu_vault_key --name "password_var"

Encryption successful  
password_var: !vault |  
          $ANSIBLE_VAULT;1.1;AES256
          32313138323133376337613162623133363866643932323436623435643266633662356533323366
          3563323733323465313438393136376665323864343266300a386339646332346135653265653761
          36383838326562376562653236356233383365366235616434356335653139306132366630646633
          3236326564386336340a633564356235306634383532323763343965666663356665623761383365
          6536

References
-----------
- [Infoblox Ansible Collection](https://github.com/infobloxopen/infoblox-ansible/tree/master)
- [NSX-T Ansible Collection](https://github.com/vmware/ansible-for-nsxt)
- [AVI Ansible Collection](https://github.com/vmware/ansible-collection-alb)
- [MSK AAP](https://tlvimsktower1.mskcc.org/#/login)
