#!/usr/bin/env bash

# Set speed
SPEED=40
bold=$(tput bold)
normal=$(tput sgr0)

# For Mac, use the following for color and nc (no color)
# color='\033[32m' # green
# # color='\033[36m' # cyan
# nc='\033[0m'

# For linux, use the following for color and nc (no color)
color='\e[1;32m' # green
nc='\e[0m'


echo -e "\n"
echo "${bold}*** KubeCon US 2019 Demo 2: Securing VM Services ***${normal}"
echo -e "\n"

echo "${bold}Checking Istio status...${normal}"
echo -e "${color}$ sudo systemctl status istio${nc}" | pv -qL $SPEED
sudo systemctl status istio
echo -e "\n"

echo "${bold}Checking Istio auth node agent status...${normal}"
echo -e "${color}$ sudo systemctl status istio-auth-node-agent${nc}" | pv -qL $SPEED
sudo systemctl status istio-auth-node-agent
echo -e "\n"

echo "${bold}Checking productcatalogservice status...${normal}"
echo -e "${color}$ sudo docker ps ${nc}" | pv -qL $SPEED
sudo docker ps 
echo -e "\n"

echo "${bold}Inspecting productcatalogservice logs...${normal}"
read -p ''
echo -e "${color}$ tail /var/log/istio/istio.log ${nc}" | pv -qL $SPEED
tail /var/log/istio/istio.log
echo -e "\n"