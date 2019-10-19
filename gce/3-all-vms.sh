#!/bin/bash

source ./add-istio-vm.sh

prep_for_vms

# assumes productcatalog is already ready
for svc in "${SERVICES[@]}" ; do
    SVC_NAME="${svc%%:*}"
    # if [ $SVC_NAME = "productcatalogservice" ]
    # then
    #     log "😴 ProductCatalog is already ready, skipping."
    #     return
    # fi

    PORT="${svc##*:}"
    GCE_IP=$(gcloud compute instances describe $SVC_NAME --zone $ZONE --format=text  | grep '^networkInterfaces\[[0-9]\+\]\.networkIP:' | sed 's/^.* //g' 2>&1)
    PROTOCOL="grpc"
    if [ $SVC_NAME = "frontend" ]
    then
        PROTOCOL="http"
    elif [ $SVC_NAME = "rediscart" ]
    then
        PROTOCOL="redis"
    else
        PROTOCOL="grpc"
    fi

    log "$GCE_IP $SVC_NAME $PORT $PROTOCOL"
    add_vm $GCE_IP $SVC_NAME $PORT $PROTOCOL
done

