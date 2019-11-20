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
echo "${bold}*** KubeCon US 2019 Demo 1: Inspecting the environment ***${normal}"
echo -e "\n"

echo "${bold}Checking Istio workloads...${normal}"
echo -e "${color}$ kubectl get pods -n istio-system${nc}" | pv -qL $SPEED
kubectl get pods -n istio-system

echo -e "\n"
echo "${bold}Checking Hipster Shop app workloads...${normal}"
read -p ''
echo -e "${color}$ kubectl get pods ${nc}" | pv -qL $SPEED
kubectl get pods

echo -e "\n"
echo "${bold}Checking Hipster Shop app services...${normal}"
read -p ''
echo -e "${color}$ kubectl get services  ${nc}" | pv -qL $SPEED
kubectl get services

echo -e "\n"
echo "${bold}Checking Hipster Shop app ServiceEntries...${normal}"
read -p ''
echo -e "${color}$ kubectl get serviceentry   ${nc}" | pv -qL $SPEED
kubectl get serviceentry

echo -e "\n"
echo "${bold}Inspecting Hipster Shop app ServiceEntries...${normal}"
read -p ''
echo -e "${color}$ kubectl get serviceentry -o yaml   ${nc}" | pv -qL $SPEED
kubectl get serviceentry -o yaml

# echo -e "\n"
# echo "${bold}Opening Hipster Shop app...${normal}"
# read -p ''
# echo -e "${color}$ kubectl get service -n istio-system | grep istio-ingressgateway   ${nc}" | pv -qL $SPEED
# kubectl get service -n istio-system | grep istio-ingressgateway

# echo -e "\n"
# echo "${bold}Opening Grafana...${normal}"
# read -p ''
# echo -e "${color}$ istioctl dashboard grafana &    ${nc}" | pv -qL $SPEED
# istioctl dashboard grafana &

# echo -e "\n"
# echo "${bold}Opening Kiali...${normal}"
# read -p ''
# echo -e "${color}$ istioctl dashboard grafana &    ${nc}" | pv -qL $SPEED
# istioctl dashboard grafana &