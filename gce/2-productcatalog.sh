#!/bin/bash

source ./add-istio-vm.sh

SVC_NAME="productcatalogservice"
PORT="3550"
PROTOCOL="grpc"
GCE_IP=$(gcloud compute instances describe $SVC_NAME --zone $ZONE --format=text  | grep '^networkInterfaces\[[0-9]\+\]\.networkIP:' | sed 's/^.* //g' 2>&1)

add_vm $GCE_IP $SVC_NAME $PORT $PROTOCOL
log "️🌈 Done with ProductCatalog!"