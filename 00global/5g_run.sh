#!/bin/bash

###
# Define vars
###

#. ./Local
#. ./Global


###
# Execute Docker run
###

echo "> Starting Docker $NODE_NAME with $DOCKER_CMD cmd"
echo $CONSOLE_BR 
echo "# REPO_NAME=$REPO_NAME"
echo "# NODE_NAME=$NODE_NAME"
echo "# NODE_VERSION=$NODE_VERSION"
echo "# NET_NAME=$NET_NAME"
echo "# DOCKER_NET=$DOCKER_NET"
echo "# DOCKER_RUN=$DOCKER_RUN"
echo "# ROLE_IP=$ROLE_IP"
echo "# DOCKER_CMD=$DOCKER_CMD"
echo $CONSOLE_BR 

(set -x; pwd)
echo $CONSOLE_BR

read -p "Press enter to continue"
clear

# ADD "--net " docker command and select default or other network name:
#if $DOCKER_NET == Default : echo $NET_NAME
#else echo $DOCKER_NET

if [ -z "$DOCKER_NET" ]; then
	case "$DOCKER_NET" in
		"Default" )
			DOCKER_NET="--net $NET_NAME"
			;;
		* )
			DOCKER_NET="--net $DOCKER_NET"
			;;
	esac
fi

if [ -n "$MASTER_IP" ]; then
	MASTERHOST="--add-host "$MASTER_ROLE":"$MASTER_IP
else
	MASTERHOST=""
fi
echo "MASTERHOST="$MASTERHOST
echo $CONSOLE_BR

#(set -x; sudo docker run $DOCKER_RUN $DOCKER_NET --ip $ROLE_IP -w /root --name $NODE_NAME $REPO_NAME/$NODE_NAME:$NODE_VERSION /bin/bash $DOCKER_CMD)

if [ -n $(docker inspect --format {{.Name}} $NODE_NAME) ]; then

	#conflict container already exists: ask to choose: do nothing / erase ?

	DEFAULT=$DEP_CONT
	echo $CONSOLE_HL
	read -e -p ": Container $NODE_NAME already exists ! Delete existing one ? [$DEP_YES/$DEP_NO/$DEP_QUIT] (Default: $DEP_CONT)": PROCEED
	PROCEED="${PROCEED:-${DEFAULT}}"
	if [ "${PROCEED}" == "$DEP_YES" ] ; then
		sudo docker rm $NODE_NAME
	fi
fi


(set -x; sudo docker run -e "ROS_MASTER_URI=$ROS_MASTER_URI" $DOCKER_RUN --net $NET_NAME --hostname $NODE_NAME $MASTERHOST -w /root --name $NODE_NAME $REPO_NAME/$NODE_NAME:$NODE_VERSION /bin/bash $DOCKER_CMD)

echo "# Docker run finished"
echo $CONSOLE_BR

read -p "Press enter to continue"
clear
