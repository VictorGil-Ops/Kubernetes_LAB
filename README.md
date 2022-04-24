# ansible-install-kubernetes-centos8

This repository contain a playbook for kubernetes cluster easy installation based in Centos 8.

For prepare virtual machines with [Vagrant](https://github.com/edib/many_vagrant_machines).

## Preparare Ansible Control Node

I use [WSL](https://docs.microsoft.com/en-us/windows/wsl/install) or MSYS2.

> Intall requisite - ansible.posix

```bash

ansible-galaxy collection install ansible.posix

```

![Image](https://github.com/VictorGil-Ops/Ansible-install-kubernetes/blob/main/image/diagram.png)

1. Create ansible user

```bash

sudo adduser ansible
sudo passwd ansible

```

2. Generate ssh key, path "~/.ssh/id_rsa.pub"

```bash
su - ansible
mkdir .ssh && cd .ssh
ssh-keygen -t rsa
cat id.rsa.pub ## paste inside ssh_prepare_node.sh << PASTE PUBLIC_KEY

```

3. Copy the public key in `prepare_nodes\prepare_node.sh` << PASTE PUBLIC_KEY

4. Execute the script on kubernetes each k8s node.

This script create a ansible user and add the ssh key inside `authorized_keys`.

## Ansible playbook

1. Check and modify the file 'inventory' and add your ip nodes

> example:

```bash

[master]
master-node ansible_host=192.168.205.212

[workers]
worker-node1 ansible_host=192.168.205.211
worker-node2 ansible_host=192.168.205.212

```

2. Run a playbook

```bash

    ansible-playbook runme.yml -v

```

## MANAGE THE CLUSTER

[Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
