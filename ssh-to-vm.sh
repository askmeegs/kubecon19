#!/usr/bin/env bash

PROJECT_ID="kubecon-san-diego"
ZONE="us-central1-a"
SVC_NAME="products"

gcloud compute ssh --project=${PROJECT_ID} --zone=${ZONE} "${SVC_NAME}"