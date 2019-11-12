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

POD=$(kubectl get pod -l app=adservice -o jsonpath="{.items[0].metadata.name}")

echo -e "\n"
echo "${bold}*** KubeCon US 2019 Demo 2: Securing VM Services ***${normal}"
echo -e "\n"

echo "${bold}Checking mTLS status...${normal}"
echo -e "${color}$ istioctl authn tls-check $POD${nc}" | pv -qL $SPEED
istioctl authn tls-check $POD 

echo -e "\n"
echo "${bold}Inspecting Istio mTLS resources...${normal}"
read -p ''
echo -e "${color}$ cat mtls.yaml ${nc}" | pv -qL $SPEED
cat mtls.yaml 

echo -e "\n"
echo "${bold}Applying Istio mTLS resources...${normal}"
read -p ''
echo -e "${color}$ kubectl apply -f mtls.yaml ${nc}" | pv -qL $SPEED
kubectl apply -f mtls.yaml

echo -e "\n"
echo "${bold}Inspecting Istio auth status...${normal}"
read -p ''
echo -e "${color}$ istioctl authn tls-check $POD ${nc}" | pv -qL $SPEED
istioctl authn tls-check $POD