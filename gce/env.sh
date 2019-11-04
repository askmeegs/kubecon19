#!/bin/bash

ISTIO_VERSION="1.3.4"
PROJECT_ID="${PROJECT_ID:?PROJECT_ID env variable must be specified}"
ZONE="us-central1-a"
CLUSTER_NAME="istio"
CTX="gke_${PROJECT_ID}_${ZONE}_${CLUSTER_NAME}"
SERVICE_NAMESPACE="default"

SERVICES=("your-gce-instance:3306")
DOCKER_RUN_ENV=""
