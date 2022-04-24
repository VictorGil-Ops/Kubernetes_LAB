# Deployment Kubernetes cluster with Ansible

&#9762; `this repo based in a itwonderland lab, thanks for it https://www.itwonderlab.com `

- Repository contains a playbook for kubernetes cluster easy installation based in Centos 8.

- You can prepare virtual machines with a [Vagrant](https://github.com/edib/many_vagrant_machines).

## Preparare Ansible Control Node

- I use [WSL](https://docs.microsoft.com/en-us/windows/wsl/install) or [MSYS2](https://www.msys2.org/).

> Intall requisite - Ansible and ansible.posix

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

3. Copy the public key in `prepare_nodes\prepare_nodes.sh` show it for more info.

4. Execute the script `prepare_nodes.sh` on kubernetes for each one k8s node.

This script create a ansible user and add the ssh key inside `.ssh/authorized_keys`.

## Ansible playbook

1. Check and modify the file `inventory` and add your ip nodes

> file: inventory

```bash

[master]
master-node ansible_host=192.168.205.212

[workers]
worker-node1 ansible_host=192.168.205.211
worker-node2 ansible_host=192.168.205.212

```

2. Check a defaut vars

> file: edit.vars.yml

```bash

master_admin_user: "ansible"
master_admin_group: "ansible"

master_apiserver_advertise_address: "192.168.205.210"
master_pod_network_cidr: "192.168.112.0/20"

master_node_name: "k8s-m"
node_node_name: "k8s-n"
cluster_name: "k8s-cluster"

# Check the last version https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
dashboard_version: "v2.5.0"

```

3. How run a playbook


Mark or desmark role

```bash
---
- import_playbook: roles/deploy-k8s-nodes.yml
#- import_playbook: roles/deploy-dashboard.yml

```
Run

```bash

 ansible-playbook run.me.yml -v

```

Copy KUBECONFIG to local:

```bash

scp ansible@master-node:/home/ansible/.kube/config ~/.kube/config

```

Access to dashboard:

` https://master-node:30002/#/login `

You find the token inside ` roles/k8s-cluster-dash_token-join-command `.

Add ROLES label to workers nodes:

```bash

 kubectl label node worker-node1 node-role.kubernetes.io/worker=worker
 kubectl label node worker-node2 node-role.kubernetes.io/worker=worker

```

## MANAGE CLUSTERS HELP

- [Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)

- [Kubernet Objects](https://kubernetes.io/es/docs/concepts/overview/working-with-objects/)

- [kubectl](https://kubernetes.io/docs/reference/kubectl/)

## Roadmap TODO

- &#9989; deploy dashboard
- &#9744; enable and configure firewall
- &#9744; istio deployment
