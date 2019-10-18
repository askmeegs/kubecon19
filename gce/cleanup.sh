#!/bin/bash

set -euo pipefail
log() { echo "$1" >&2; }

source ./env.sh

delete_vm () {
    # gcloud compute firewall-rules delete k8s-to-$1-gce -q
    gcloud compute instances delete $1 --zone=$ZONE -q
}

# delete cluster
gcloud config set project $PROJECT_ID
gcloud container clusters delete $CLUSTER_NAME --zone $ZONE --async -q

for svc in "${SERVICES[@]}" ; do
    SVC_NAME="${svc%%:*}"
    delete_vm $SVC_NAME
done

