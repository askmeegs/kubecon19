#!/bin/bash

gcloud compute firewall-rules delete k8s-to-productcatalogservice-gce --quiet
gcloud compute instances delete productcatalogservice --zone us-central1-a --quiet
kubectl delete -f hipstershop/
kubectl delete -f mtls/
kubectl delete -f traffic-splitting/
kubectl delete namespace istio-system
rm istio.yaml
rm -rf istio-*
rm -rf gce/temp