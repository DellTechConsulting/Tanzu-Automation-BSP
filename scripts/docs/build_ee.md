Steps for Building an AAP Execution Environment
-----------
1. First install the python dependencies via pip.  
`pip3 install ansible-builder  --user`  
2.  Change directory to the "ee" directory where the [execution-environment.yml](../ee/execution-environment.yml) file is located.  
3.  Build the container file  
`ansible-builder create`
4.  Login to the redhat registry 
`podman login registry.redhat.io`
5.  Build the container file.  You may have to do this as root with 'dzdo due to permissions on the server.  
`podman build -f context/Containerfile -t dell_ansible_ee:1.0`
6.  Tag the build with the automation hub's uri.  
`podman tag localhost/dell_ansible_ee:latest plvaaphub.dellcc.org/dell_ansible_e`
7.  Login to the Automation hub with podman.  
`podman login --tls-verify=false -u bondj plvaaphub.dellcc.org `  
8.  Push the container to the automation hub.  
`podman push plvaaphub.dellcc.org/dell_ansible_ee --tls-verify=false`


References
-----------
- [DELL Automation Hub](https://plvaaphub.dellcc.org/ui/containers/dell_ansible_ee)
- [Ansible Builder](https://www.ansible.com/blog/introduction-to-ansible-builder)
