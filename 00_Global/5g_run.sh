#!/bin/bash

########################################################################
# Define vars
########################################################################

#. ./Local
#. ./Global


########################################################################
# Execute Docker run
########################################################################

echo ">>>> Starting Docker $NODE_NAME with $DOCKER_CMD cmd"
echo $CONSOLE_BR 
#echo ">>>> Starting Docker $NODE_NAME"
echo "#### REPO_NAME=$REPO_NAME"
echo "#### NODE_NAME=$NODE_NAME"
echo "#### NODE_VERSION=$NODE_VERSION"
echo "#### DOCKER_RUN=$DOCKER_RUN"
echo "#### NET_NAME=$NET_NAME"
echo "#### ROLE_IP=$ROLE_IP"
echo "#### DOCKER_CMD=$DOCKER_CMD"
echo $CONSOLE_BR 

(set -x; pwd)
echo $CONSOLE_BR

# ADD "--net " docker command if $NET_NAME exists
if [ !$NET_NAME ]; then
	$NET_NAME="--net "$NET_NAME
fi

(set -x; sudo docker run $DOCKER_RUN $NET_NAME --ip $ROLE_IP -w /root --name $NODE_NAME $REPO_NAME/$NODE_NAME:$NODE_VERSION /bin/bash $DOCKER_CMD)

echo "#### Docker run finished"
echo $CONSOLE_BR 
