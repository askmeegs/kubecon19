#!/usr/bin/env bash

# Set speed
SPEED=40
bold=$(tput bold)
normal=$(tput sgr0)

color='\033[32m' # green
# color='\033[36m' # cyan
nc='\033[0m'

# For linux, use the following for color and nc vars
# color='\e[1;32m' # green
# nc='\e[0m'


echo -e "\n"
echo "${bold}*** KubeCon US 2019 Demo 3: Traffic Splitting ***${normal}"

echo -e "\n"
echo "${bold}Running productcatalogservice on GKE cluster...${normal}"
read -p ''
echo -e "${color}$ kubectl apply -f traffic-splitting/productcatalog.yaml${nc}" | pv -qL $SPEED
kubectl apply -f traffic-splitting/productcatalog.yaml

echo -e "\n"
echo "${bold}Applying VirtualService...${normal}"
read -p ''
echo -e "${color}$ kubectl apply -f traffic-splitting/split-traffic.yaml${nc}" | pv -qL $SPEED
kubectl apply -f traffic-splitting/split-traffic.yaml

echo -e "\n"
echo "${bold}Inspecting the VirtualService configured for traffic splitting...${normal}"
read -p ''
echo -e "${color}$ cat traffic-splitting/split-traffic.yaml${nc}" | pv -qL $SPEED
cat traffic-splitting/split-traffic.yaml

