#!/bin/bash

########################################################################
# Define vars
########################################################################

. ./Local
. ./Global


########################################################################
# Execute Docker run
########################################################################

echo ">>>> Starting Docker $NODE_NAME with $DOCKER_CMD cmd"
#echo ">>>> Starting Docker $NODE_NAME"
echo "#### REPO_NAME=$REPO_NAME"
echo "#### NODE_NAME=$NODE_NAME"
echo "#### NODE_VERSION=$NODE_VERSION"
echo "#### DOCKER_RUN=$DOCKER_RUN"
echo "#### NET_NAME=$NET_NAME"
echo "#### NODE_IP=$NODE_IP"
echo "#### DOCKER_CMD=$DOCKER_CMD"


sudo docker run \
 $DOCKER_RUN \
 --net $NET_NAME \
 --ip $NODE_IP \
 -w /root \
 --name $NODE_NAME \
 $REPO_NAME/$NODE_NAME:$NODE_VERSION \
 $DOCKER_CMD

echo "#### Docker run finished"
echo $CONSOLE_HL 


