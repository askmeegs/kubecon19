#!/bin/bash

gcloud compute firewall-rules delete k8s-to-productcatalogservice-gce --quiet
gcloud compute instances delete productcatalogservice --zone us-east1-b --quiet
kubectl delete -f hipstershop/
kubectl delete -f mtls/
kubectl delete -f traffic-splitting/
kubectl delete namespace istio-system