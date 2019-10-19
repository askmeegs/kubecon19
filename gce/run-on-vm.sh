#!/bin/bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# set vars
ISTIO_VERSION="1.3.3"
GWIP='35.223.47.11'

# setup --  install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable";
sudo apt-get update;
sudo apt-get install -y docker-ce;

# update /etc/hosts for DNS resolution
echo -e "\n$GWIP istio-citadel istio-pilot istio-pilot.istio-system" | \
   sudo tee -a /etc/hosts

curl -L https://storage.googleapis.com/istio-release/releases/${ISTIO_VERSION}/deb/istio-sidecar.deb > istio-sidecar.deb

sudo dpkg -i istio-sidecar.deb

ls -ld /var/lib/istio

sudo mkdir -p /etc/certs
sudo cp {root-cert.pem,cert-chain.pem,key.pem} /etc/certs
sudo cp cluster.env /var/lib/istio/envoy
sudo cp sidecar.env /var/lib/istio/envoy
sudo chown -R istio-proxy /etc/certs /var/lib/istio/envoy

sudo systemctl start istio


# port exposed as "-p" AND as Env because some of the services need their own port, as a variable.
IMAGE="gcr.io/megandemo/$SVC_NAME:latest"
if [ $SVC_NAME = "redis-cart" ]
then
   IMAGE="redis:alpine"
fi

sudo docker run -d --name $SVC_NAME -p $PORT:$PORT -e "PORT=$PORT" $DOCKER_RUN_ENV $IMAGE
