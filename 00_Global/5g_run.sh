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
echo "#### REPO_NAME=$REPO_NAME"
echo "#### NODE_NAME=$NODE_NAME"
echo "#### NODE_VERSION=$NODE_VERSION"
echo "#### SWARM_NET=$SWARM_NET"
echo "#### DOCKER_NET=$DOCKER_NET"
echo "#### DOCKER_RUN=$DOCKER_RUN"
echo "#### ROLE_IP=$ROLE_IP"
echo "#### DOCKER_CMD=$DOCKER_CMD"
echo $CONSOLE_BR 

(set -x; pwd)
echo $CONSOLE_BR

# ADD "--net " docker command if $SWARM_NET exists
if [ $DOCKER_NET != "" ]; then
	case "$DOCKER_NET" in
	    "Default" )
		    DOCKER_NET="--net $SWARM_NET"
	         ;;
	    * )
		    DOCKER_NET="--net $DOCKER_NET"
	         ;;
	esac
fi

#(set -x; sudo docker run $DOCKER_RUN $DOCKER_NET --ip $ROLE_IP -w /root --name $NODE_NAME $REPO_NAME/$NODE_NAME:$NODE_VERSION /bin/bash $DOCKER_CMD)

(set -x; sudo docker run $DOCKER_RUN $DOCKER_NET --hostname $NODE_NAME -w /root --name $NODE_NAME $REPO_NAME/$NODE_NAME:$NODE_VERSION /bin/bash $DOCKER_CMD)

echo "#### Docker run finished"
echo $CONSOLE_BR 
