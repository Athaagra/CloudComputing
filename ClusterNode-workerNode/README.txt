sudo apt-get update

configuration file for containerd:

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

Load modules:

sudo modprobe overlay
sudo modprobe br_netfilter

Set system configurations for Kubernetes networking:

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

Apply new settings:

sudo sysctl --system

install containerd:

sudo apt-get update && sudo apt-get install -y containerd

Generate default containerd:

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

Restart containerd to ensure new configuration:

sudo systemctl restart containerd

Verify that containerd is running:

sudo systemctl status containerd

Disable swap:

sudo swapoff -a

Disable swap on startup in /etc/fstab:

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

install dependency packages:

sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl

Download and add the GPG key:

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg 
https://packages.cloud.google.com/apt/doc/apt-key.gpg

Update package listing:

sudo apt-get update

sudo apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00

Turn off automatic updates:

sudo apt-mark hold kubelet kubeadm kubectl

sudo kubeadm init --pod-network-cidr 192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get nodes

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/custom-resources.yaml

watch kubectl get pods -n calico-system

kubectl get nodes

kubeadm token create --print-join-command

sudo kubeadm join

kubectl get nodes


-------------------------------worker node--------------------------------------
Upgrade apt packages
sudo apt-get update

Create a configuration file for containerd:

    cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
    overlay
    br_netfilter
    EOF

Load modules:

    sudo modprobe overlay
    sudo modprobe br_netfilter


Set system configurations for Kubernetes networking:

    cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    EOF


Apply new settings:
sudo sysctl --system

Install containerd:

    sudo apt-get update && sudo apt-get install -y containerd


Create a default configuration file for containerd:

    sudo mkdir -p /etc/containerd


Generate default containerd configuration and save to the newly created default file:

    sudo mkdir -p /etc/containerd
    containerd config default | sudo tee /etc/containerd/config.toml


Restart containerd to ensure new configuration file usage:

    sudo systemctl restart containerd


Verify that containerd is running.

    sudo systemctl status containerd


Disable swap:

    sudo swapoff -a


Disable swap on startup in /etc/fstab:

    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


Install dependency packages:

    sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl


Download and add the GPG key:

    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg


Add Kubernetes to the repository list:

    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


Update package listings:

    sudo apt-get update


Install Kubernetes packages (Note: If you get a dpkg lock message, just wait a minute or two before trying the command again):

    sudo apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00


Turn off automatic updates:

    sudo apt-mark hold kubelet kubeadm kubectl
