PROJECT_ID="kubecon-san-diego"
gcloud config set project $PROJECT_ID
ZONE="us-central1-a"
CLUSTER_NAME="istio"
CTX="gke_${PROJECT_ID}_${ZONE}_${CLUSTER_NAME}"
SVC_NAME="products"
SERVICE_NAMESPACE="default"
PORT="3550"
ISTIO_VERSION="1.3.4"
