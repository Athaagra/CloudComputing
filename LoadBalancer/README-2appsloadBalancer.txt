1) Start the minikube instance:
minikube start --cpus=4 --memory=8g --force


2) Metallb is enabled: 
kubectl get pods -n metallb-system

3) Metallb is configured: 
kubectl get configmap config -n metallb-system -o yaml
"protocol: layer2
 addresses:
 - 192.168.59.20-192.168.59.30"

4)Istio release archive
export ISTIO_VERSION=1.12.1
wget -c -nv \
https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-amd65.tar.gz
tar -xzf istio-${ISTIO_VERSION}-linux-amd64.tar.gz
rm -v istio-${ISTIO_VERSION}-linux-amd64.tar.gz

5) Istioctl executable:
export PATH="${PATH}:${HOME}/bin"
(optional)
mkdir -vp ¬/bin
install --mode 0755 istio-${ISTIO_VERSION}/bin/istioctl ¬/bin/
(optional)
echo 'export PATH="${PATH}:${HOME}/bin"' | tee -a ¬/.bashrc

6) Istioctl verify:
 which istioctl

istioctl version

7) Istio pre installation:
istioctl experimental precheck

8) Istio install in the kubernetes cluster (the parameter profile can be set to minimal(minimum requirements),default(default parameters)):
istioctl install --set profile=demo -y

9) configuration of istioctl (in casel of the use of helm two namespaces are created istio-system, istio-ingress):
kubectl get deployments,pods - istio-system

10) The deployment produces the ingress and engress gateway in the namespace istio-system:
kubectl get services -n istio-system

11) Get the istio IP address:
kubectl get service istio-ingressgateway \
 -n istio-system \
 -o jsonpath='{.status.loadBalancer.ingress[0].ip}{"\n"}'
192.168.59.20

export INGRESS_HOST="192.168.59.20"

11.a (same outcome with step 11.))You can export the IP address by using a single command:

export INGRESS_HOST=$(kubectl get service \
istio-ingressgateway - istio-system \
 -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

12) Get the Istio Port: 
kubectl get service istio-ingressgateway \
 -n istio-system \
 -ο jsonpath='{.spec.ports[?(@.name=="http2")].port}{"\n"}'
80
export INGRESS_PORT="80"

kubectl get service istio-ingressgateway \
 -n istio-system \
 -ο jsonpath='{.spec.ports[?(@.name=="https")].port}{"\n"}'
443

export SECURE_INGRESS_PORT="443"

12a (same outcome with step 12.)You can export the port number by using a single command: 
export INGRESS_PORT=$(kubectl get service \
 istio-ingressgateway -n istio-system \
 -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')

export SECURE_INGRESS_PORT=$(kubectl get service \
 istio-ingressgateway -n istio-system \
 -o jsonpath='{.spec.ports[?(@.name=="https")].port}')

13) The address that your application will display is:
export GATEWAY_URL="${INGRESS_HOST}:${INGRESS_PORT}"
192.168.59.20:80

14) Enable istio addons (Grafana,Kiali,jaeger,prometheus):
ISTIO_VERSION=1.12.1
ls istio-${ISTIO_VERION}/samples/addons/
kubectl apply -f istio-${ISTIO_VERSION}/samples/addons
kubectl get deployments -n istio-system

15) Applications exposure (enabel sidecar injection for the default namespace):
kubectl label namespace default istio-injection=enabled --overwrite
export ISTIO_VERSION=1.12.1
kubectl apply -f \
istio-${ISTIO_VERSION}/samples/helloworld/helloworld.yaml

16) Display the applications that are deployed earlier in the namespace default: 
kubectl get deployments, pods -l app=helloworld

output:
helloworld   ClusterIP   10.101.60.68   <none>        5000/TCP   3m

17) Create the gateway ad virtual service:
kubectl apply -f \
istio-${ISTIO_VERSION}/samples/hellowordl/helloworld-gateway.yaml

18) Verify that the gateway and virtual services are deployed the gateway(refers to the ip of each apllication and a port traffic(ingress rul1) with a domain name) the virtual services make use of the gateways or destination rule to simulate a load balancer(Virtual Services,weight 10% of connections visit the v1 Hello World 90% of connections visit the v2 Hello Wolrd):
kubectl get gateways,virtualservices

19) Get the URL prefixes:
kubectl get virtualservice helloworld \
  -o jsonpath='{.spec.http[0].match[0].uri}{"\n"}'
{"exact":"/hello"}

20) Test the load balancer:
curl "http://${GATEWAY_URL}/hello"
20a)
curl 192.168.59.20
output:
Hellov1 
-refresh
Hellov2

21) Iterate tool to curl the page a number of times:
grep -v '^#' \
  istio-${ISTIO_VERSION}/samples/helloworld/loadgen.sh

while true; do curl -s -o /dev/null "http://$GATEWAY_URL/hello"; done

./istio-${ISTIO_VERSION}/samples/helloworld/loadgen.sh

22) Monitor the traffic with Kiali addon(default as set), recommended grafana also:
istioctl dashboard kiali
output:
http://localhost:20001/kiali
(leave terminal and browse it until your monitor to finish)
