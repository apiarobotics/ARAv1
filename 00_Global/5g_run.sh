#!/bin/bash

########################################################################
# Define vars
########################################################################

. ./Local
. ./Global


########################################################################
# Execute Docker run
########################################################################

echo ""
#echo ">>>> Starting Docker $NODE_NAME with $DOCKER_CMD cmd"
echo ">>>> Starting Docker $NODE_NAME"

sudo docker run \
 $DOCKER_RUN \
 --net ara \
 --ip $NODE_IP \
 -w /root \
 --name $NODE_NAME \
 arav1/$NODE_NAME:$NODE_VERSION \
# $DOCKER_CMD

echo "#### Docker run finished"
echo ""


