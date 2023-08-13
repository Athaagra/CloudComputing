Unistall Docker CE Edition
---------------------------
sudo apt-get remove docker docker-engine docker.io containerd runc

Installation of transport https, certificates, curl, gnupg, lsb-release
----------------------------------------------------------------------
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg \
     lsb-release

Add Docker's official GPG key:
----------------------------------
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

Setup repository:
----------------------------
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg) https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

apt-cache madison docker-ce | awk '{ print $3 }'

VERSION_STRING=5:20.10.8¬3-0¬ubuntu-bionic
sudo apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin

Install kubectl binary via curl:
---------------------------------------------------
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

download specific version:
---------------------------------
$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

Download version 1.24.0 :
----------------------------------
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.24.0/bin/linux/amd64/kubectl

make it binary:
--------------------------------------
chmod +x ./kubectl

binary to path:
--------------------------------------
sudo mv ./kubectl /usr/local/bin/kubectl

version of kubectl

kubectl version --client

Install Minikube v1.22.0:
------------------------
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.22.0/minikube-linux-amd64 

latest version:
-----------------------
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

move bin:
------------------------
sudo cp minikube /usr/local/bin/minikube

sudo chmod 755 /usr/local/bin/minikube

minikube version
sudo apt install conntrack

#### Start minikube ####
-------------------------------------
sudo minikube start --cpus=4 --memory=8g --force

sudo kubectl get pods -n kube-system

sudo minikube profile list

output:
|minikube|docker|docker|192.168.49.2|8443|v1.21.2|Running|1|
------------------------------------------------------------
VMware:
-------------------------------
VM->Edit->Virtual Network Editor->Host Only range 192.168.49.0 - 192.168.49.100 Apply DHCP (the Load Balancer ip shoud contained in the range except the minikube ip)
VM->Setings->Network Adapter-> Custom: Specific virtual network
-------------------------------------------------------
sudo minikube addons list

sudo minikube addons enable metallb

sudo minikube addons configure metallb
192.168.49.100
192.168.49.110

sudo minikube get configmap/config -n metallb-system -o yaml

kubectl create deployment nginx --image quay.io/redhattraining/nginx:1.21 --port 80

kubectl get deployments,pods -l app=nginx

kubectl expose deployment nginx --type LoadBalancer --port 80 --target-port 80

kubectl get services -l app=nginx
------------------------------------------------------------------------------
|nginx     LoadBalancer     10.96.5.59     192.168.49.100      80:32110/TCP    10m

External IPs, Cluster IP:
------------------------------
curl 192.168.49.2:32110

Load Balancer IP:
-----------------------------------
curl 192.168.49.100:80
