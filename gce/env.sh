#!/bin/bash

ISTIO_VERSION="1.3.3"
PROJECT_ID="${PROJECT_ID:?PROJECT_ID env variable must be specified}"
ZONE="us-central1-b"
CLUSTER_NAME="istio"
CTX="gke_${PROJECT_ID}_${ZONE}_${CLUSTER_NAME}"
SERVICE_NAMESPACE="default"

SERVICES=("httpbin:80"
          "loadgen-httpbin:80")

# SERVICES=("redis-cart:6379"
#         "adservice:9555"
#         "cartservice:7070"
#         "checkoutservice:5050"
#         "currencyservice:7000"
#         "emailservice:5000"
#         "frontend:80"
#         "paymentservice:50051"
#         "productcatalogservice:3550"
#         "recommendationservice:8080"
#         "shippingservice:50051"
#         "loadgenerator:8080")

DOCKER_RUN_ENV=""

# DOCKER_RUN_ENV="-e FRONTEND_ADDR=frontend:80 -e USERS=10 -e REDIS_ADDR=redis-cart:6379 -e LISTEN_ADDR=0.0.0.0 -e PRODUCT_CATALOG_SERVICE_ADDR=productcatalogservice:3550 -e SHIPPING_SERVICE_ADDR=shippingservice:50051 -e PAYMENT_SERVICE_ADDR=paymentservice:50051 -e EMAIL_SERVICE_ADDR=emailservice:5000 -e CURRENCY_SERVICE_ADDR=currencyservice:7000 -e CART_SERVICE_ADDR=cartservice:7070 -e JAEGER_SERVICE_ADDR=jaeger-collector:14268 -e RECOMMENDATION_SERVICE_ADDR=recommendationservice:8080 -e  CHECKOUT_SERVICE_ADDR=checkoutservice:5050 -e AD_SERVICE_ADDR=adservice:9555"