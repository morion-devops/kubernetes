
# Kubernetes
Deploy k8s cluster via [kubespray](https://github.com/kubernetes-sigs/kubespray). 

Also has two custom roles:

  1. ~~**containerd-insecure-registry**. My installation of Docker Registry has only self-signed certificate. But containerd do not trust such registries by default ([and kubespray don't have such option](https://github.com/kubernetes-sigs/kubespray/issues/7060)), so I configure it to trust my instance.~~

      > I have been [backported](https://github.com/kubernetes-sigs/kubespray/pull/8298) this feature in kubespray. So now kubespray supports insecure registries for containerd out of box.

  1. **kubectl-set-config**. kubespray has parameter `kubeconfig_localhost` which can copy kubeconfig to local machine. But I need more comfort way — I want to add parameters in my existed kubeconfig, and don't to have individual file. So I created role, that add this cluster in my existed kubeconfig-file.


## How to provisioning:

1. `vagrant up`
1. `pip3 install -r kubespray/requirements.txt`
1. `cd kubespray/inventory`
1. `ln -s ../../inventory/mycluster mycluster`
1. `cd ..`
1. `ansible-playbook -i inventory/mycluster/hosts.ini  --become --become-user=root cluster.yml`
1. `cd ..`
1. `ansible-playbook -i inventory/mycluster/hosts.ini  --become --become-user=root playbook.yaml`
