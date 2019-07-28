#!/bin/bash
source config

export $GLOBAL_PATH="../../00_Global"

clear
echo ""
echo " ***  Welcome to ARA installation program  *** "
echo $CONSOLE_HL 
echo ""
echo "#### please refer to apiarobotics.com to get informed for updates or new services"
echo $CONSOLE_HL 

#Install Docker
echo ""
echo ":::: Checking prerequisites: Docker"
echo $CONSOLE_HL 

if [ $(docker -v) == "NULL" ]
then
    echo ">>>> Installating Docker"
    sudo apt install curl
    curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
    sudo usermod -aG docker $(whoami)
    echo "#### $(docker -v) installed: OK"
else
    echo "#### $(docker -v) is already installed: OK"
fi

#Create overlay network
DEFAULT="N"
read -e -p "Create overlay network ? [N/y/q] ": PROCEED
PROCEED="${PROCEED:-${DEFAULT}}"
if [ "${PROCEED}" == "y" ] ; then 
    echo ""
    echo ":::: Docker: Create overlay network"
    echo $CONSOLE_HL 
    sudo docker network create -d overlay $APP_NAME
else
    echo "#### Network creation aborded !"
fi

#Proceeding installation
echo ""
echo ":::: Execution processing"
echo $CONSOLE_HL 

for i in [2-5][gd]*; do
    DEFAULT="N"
    read -e -p "Execute: $i ? [N/y/q]:" PROCEED 
    PROCEED="${PROCEED:-${DEFAULT}}"
    if [ "${PROCEED}" == "y" ] ; then
        echo ""
        echo ">>>> Step $i: Executing"
        echo $CONSOLE_HL 
        /bin/bash $i
        echo "#### Step $i: Finished" 
        echo ""
    else
        echo "#### Execution $i aborded !"
    fi
done

