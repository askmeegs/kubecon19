#!/usr/bin/env bash

# Set speed
SPEED=40
bold=$(tput bold)
normal=$(tput sgr0)

# For Mac, use the following for color and nc (no color)
color='\033[32m' # green
# # color='\033[36m' # cyan
nc='\033[0m'

# For linux, use the following for color and nc (no color)
# color='\e[1;32m' # green
# nc='\e[0m'


echo -e "\n"
echo "${bold}*** Resetting Demo ***${normal}"

echo -e "\n"
echo -e "${color}$ kubectl delete -f traffic-splitting/split-traffic.yaml ${nc}"
kubectl delete -f traffic-splitting/split-traffic.yaml

echo -e "\n"
echo -e "${color}$ kubectl delete -f traffic-splitting/productcatalog.yaml ${nc}"
kubectl delete -f traffic-splitting/productcatalog.yaml

echo -e "\n"
echo -e "${color}$ kubectl delete -f mtls.yaml ${nc}"
kubectl delete -f mtls.yaml