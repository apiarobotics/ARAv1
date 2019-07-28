#!/bin/bash

APP_NAME=ara

echo "Welcome to ARA installation program"
echo "-- -- -- -- -- -- -- -- -- -- -- --"
echo "please refer to apiarobotics.com to get informed for updates or new services"
echo "-- -- -- -- -- -- -- -- -- -- -- --"

#Install Docker
echo "\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/"
echo "Checking prerequisites: Docker"
echo "/\_/\_/\_/\_/\_/\_/\_/\_/\_/\"
if [ $(docker -v) == NULL ]
then
    echo "#### Installating Docker"
    sudo apt install curl
    curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
    sudo usermod -aG docker $(whoami)
    echo "#### Docker version:$(docker -v) installed: OK"
else
    echo "#### Docker version:$(docker -v) is already installed: OK"
fi

#Create overlay network
echo "\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/"
echo "Docker: Create overlay network"
echo "/\_/\_/\_/\_/\_/\_/\_/\_/\_/\"
sudo docker network create -d overlay $APP_NAME

#create simlinks for global files
sh a1_simlinks.sh

#run worksteps 
echo "\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/"
echo "Proceeding installation"
echo "/\_/\_/\_/\_/\_/\_/\_/\_/\_/\"
/bin/bash 0_init.sh
