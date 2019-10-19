#!/bin/bash

source ./add-istio-vm.sh
source ./env.sh

# assumes productcatalog is already ready
for svc in "${SERVICES[@]}" ; do
    SVC_NAME="${svc%%:*}"

    PORT="${svc##*:}"
    GCE_IP=$(gcloud compute instances describe $SVC_NAME --zone $ZONE --format=text  | grep '^networkInterfaces\[[0-9]\+\]\.networkIP:' | sed 's/^.* //g' 2>&1)
    PROTOCOL="http"
    # if [ $SVC_NAME = "frontend" ]
    # then
    #     PROTOCOL="http"
    # elif [ $SVC_NAME = "redis-cart" ]
    # then
    #     PROTOCOL="redis"
    # else
    #     PROTOCOL="grpc"
    # fi

    log "$GCE_IP $SVC_NAME $PORT $PROTOCOL"
    add_vm $GCE_IP $SVC_NAME $PORT $PROTOCOL
done

