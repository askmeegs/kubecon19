#!/bin/bash

set -euo pipefail
log() { echo "$1" >&2; }
source ./env.sh

# NOTE - if you are on a mac and you don't have gsed, uncomment this line:
#  brew install gnu-sed

# Get GKE cluster info that applies to all the service VMs
prep_for_vm () {
    GCE_IP=$1
    SVC_NAME=$2
    PORT=$3
    PROTOCOL=$4

    #setup
    source ./env.sh
    gcloud config set project $PROJECT_ID
    gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE
    kubectl config use-context $CTX
    GWIP=$(kubectl get -n istio-system service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    ISTIO_SERVICE_CIDR=$(gcloud container clusters describe ${CLUSTER_NAME?} --zone ${ZONE?} --project ${PROJECT_ID?} --format "value(servicesIpv4Cidr)")

    # generate cluster.env from the GKE cluster
    echo -e "ISTIO_SERVICE_CIDR=$ISTIO_SERVICE_CIDR\n" | tee temp/cluster.env
    echo "ISTIO_INBOUND_PORTS=${PORT}" >> temp/cluster.env
    echo "ISTIO_CP_AUTH=MUTUAL_TLS" >> temp/cluster.env

    # Get istio control plane certs
    kubectl -n ${SERVICE_NAMESPACE?} get secret istio.default \
    -o jsonpath='{.data.root-cert\.pem}' | base64 --decode | tee temp/root-cert.pem
    kubectl -n ${SERVICE_NAMESPACE?} get secret istio.default \
    -o jsonpath='{.data.key\.pem}' | base64 --decode | tee temp/key.pem
    kubectl -n ${SERVICE_NAMESPACE?} get secret istio.default \
    -o jsonpath='{.data.cert-chain\.pem}' | base64 --decode | tee temp/cert-chain.pem

    # generate sidecar.env
    cp temp/cluster.env temp/sidecar.env

    # populate the configure script
    pattern='GWIP=""'
    replace="GWIP='$GWIP'"
    gsed -r -i "s|$pattern|$replace|g" ./run-on-vm.sh
    log "✅done"
}

# $1 = GCE IP, $2 = SVC_NAME, $3 = PORT, $4 = PROTOCOL
add_vm () {
    GCE_IP=$1
    SVC_NAME=$2
    PORT=$3
    PROTOCOL=$4

    log "⏰ Adding $SVC_NAME to the mesh..."
    source ./env.sh
    # rm -r ./temp/*
    prep_for_vm $GCE_IP $SVC_NAME $PORT $PROTOCOL

    # scp certs, env file, and script to the GCE instance
    log "sending cluster.env, sidecar.env, certs, and script to the $2 VM..."
    gcloud compute --project ${PROJECT_ID?} scp --zone ${ZONE?} ./run-on-vm.sh temp/sidecar.env temp/cluster.env temp/*.pem $SVC_NAME:

    log "creating Istio resources..."
    ../gke/istio-${ISTIO_VERSION}/bin/istioctl register $SVC_NAME $GCE_IP "$PROTOCOL:${PORT}"

    PROTOCOL_UPPER=$(echo $PROTOCOL | tr a-z A-Z)

    kubectl apply -n $SERVICE_NAMESPACE -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: ${SVC_NAME}
spec:
  hosts:
  - ${SVC_NAME}.default.svc.cluster.local
  location: MESH_INTERNAL
  ports:
  - number: ${PORT}
    name: ${PROTOCOL}
    protocol: ${PROTOCOL_UPPER}
  resolution: STATIC
  endpoints:
  - address: ${GCE_IP}
    ports:
      ${PROTOCOL}: ${PORT}
    labels:
      app: ${SVC_NAME}
EOF

    # ssh into the VM and run that script
    log "🛸 ssh-ing into the $SVC_NAME VM to finish up..."

    gcloud compute ssh --zone $ZONE $SVC_NAME -- "DOCKER_RUN_ENV=\"${DOCKER_RUN_ENV}\" SVC_NAME=$SVC_NAME PORT=$PORT ./run-on-vm.sh"
    log " ✅ Done adding $SVC_NAME"
}

