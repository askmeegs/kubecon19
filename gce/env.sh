#!/bin/bash

ISTIO_VERSION="1.3.3"
PROJECT_ID="${PROJECT_ID:?PROJECT_ID env variable must be specified}"
ZONE="us-central1-b"
CLUSTER_NAME="istio"
CTX="gke_${PROJECT_ID}_${ZONE}_${CLUSTER_NAME}"
SERVICE_NAMESPACE="default"

SERVICES=("productcatalogservice:3550")
DOCKER_RUN_ENV=""
