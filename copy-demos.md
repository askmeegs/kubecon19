# GKE Demo 1
```
kubectl get pods -n istio-system

kubectl get pods

kubectl get services

kubectl get serviceentry

cat serviceentry.yaml
```

# VM Demo 1

```
sudo systemctl status istio

sudo systemctl status istio-auth-node-agent

sudo docker ps

tail /var/log/istio/istio.log
```

# Demo 2 - mTLS
```
POD=$(kubectl get pod -l app=adservice -o jsonpath="{.items[0].metadata.name}")

istioctl authn tls-check $POD

cat mtls.yaml

kubectl apply -f mtls.yaml

istioctl authn tls-check $POD
```

# Demo 3 - traffic splitting

```
kubectl apply -f traffic-splitting/productcatalog.yaml

kubectl get services -n default | grep productcatalogservice

kubectl get endpoints -n default | grep productcatalogservice

kubectl apply -f traffic-splitting/split-traffic.yaml

cat traffic-splitting/split-traffic.yaml
```