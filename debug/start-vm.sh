#!/bin/bash

set -euo pipefail
log() { echo "$1" >&2; }

source ./env.sh

# set vars
K8S_POD_CIDR=$(gcloud container clusters describe ${CLUSTER_NAME?} --zone ${ZONE?} --format=json | jq -r '.clusterIpv4Cidr')

# setting up 1 VM
start_vm () {
    gcloud compute firewall-rules create k8s-to-$1-gce \
    --description="Allow k8s pods CIDR to istio-gce instance" \
    --source-ranges=$K8S_POD_CIDR \
    --target-tags=$1 \
    --action=ALLOW \
    --rules=tcp:$2

    gcloud compute --project=$PROJECT_ID instances create "${SVC_NAME}" --zone=$ZONE \
    --machine-type=n1-standard-2 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE \
    --image=ubuntu-1604-xenial-v20191010 --image-project=ubuntu-os-cloud --boot-disk-size=10GB \
    --boot-disk-type=pd-standard --boot-disk-device-name=$SVC_NAME --tags=$SVC_NAME
}

# set project / allow user SSH to the VMs
gcloud config set project $PROJECT_ID

log "Starting VM for $SVC_NAME, port $PORT ..."
start_vm $SVC_NAME $PORT
