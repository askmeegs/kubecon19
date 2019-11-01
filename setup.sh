#!/bin/bash

ISTIO_VERSION="1.3.3" ./gke/install-istio.sh
cd gce
./1-start-vms.sh
./2-productcatalog.sh
cd ..

kubectl apply -f hipstershop/