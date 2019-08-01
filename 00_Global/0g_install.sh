#!/bin/bash

clear

########################################################################
# Define vars 
########################################################################
#source Local (local param file) and get $GLOBAL_PATH
. ./Local

#use $GLOBAL_PATH to source Global (global param file)
. ./$GLOBAL_PATH/Global


########################################################################
# Intro message
########################################################################

echo " *************************************************** "
echo " ***  Welcome to $APP_NAME:$APP_VERSION/$NODE_NAME:$NODE_VERSION installation program  *** "
echo " *************************************************** "
echo "#### please refer to apiarobotics.com to get informed for $APP_NAME updates or new services"

echo "#### Param values from Local are: "
echo " - - GLOBAL_PATH=$GLOBAL_PATH"
echo " - - NODE_NAME=$NODE_NAME"
echo " - - NODE_ROLE=$NODE_ROLE"
echo " - - NODE_VERSION=$NODE_VERSION"
echo " - - NODE_IP=$NODE_IP"
echo " - - SWARM_WORKER_IP=$SWARM_WORKER_IP"
echo " - - DOCKER_RUN=$DOCKER_RUN"
echo " - - DOCKER_CMD=$DOCKER_CMD"
echo " - - CATKIN=$CATKIN"
echo " - - ROSRUN_EXE=$ROSRUN_EXE"


echo "#### Param values from Global are: "
echo " - - APP_NAME=$APP_NAME"
echo " - - APP_VERSION=$APP_VERSION"
echo " - - REPO_NAME=$REPO_NAME"
echo " - - NET_NAME=$NET_NAME"
echo " - - APP_SUBNET=$APP_SUBNET"
echo " - - ROS_MASTER_URI=$ROS_MASTER_URI"
echo " - - SWARM_MANAGER_IP=$SWARM_MANAGER_IP"

echo $CONSOLE_HL 


########################################################################
# Check Docker installation and install Docker if needed
########################################################################

echo ":::: Checking prerequisites: Docker"

command -v docker >/dev/null
if [ $? -eq 0 ] ; then
    echo "#### $(docker -v) is already installed: OK"
else
    echo ">>>> Installating Docker"
    sudo apt install curl
    curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
    sudo usermod -aG docker $(whoami)
    echo "#### $(docker -v) installed: OK"
fi
echo $CONSOLE_HL 


########################################################################
# Swarm INIT (master) or JOIN (nodes) 
########################################################################

echo ":::: Swarm: INIT or JOIN"

DEFAULT="N"
read -e -p "INIT or JOIN swarm cluster ? [N/y/q] ": PROCEED
PROCEED="${PROCEED:-${DEFAULT}}"
if [ "${PROCEED}" == "y" ] ; then 
    if [ $NODE_ROLE == "master" ]; then
        echo ":::: Swarm: INIT (master)"
        docker swarm init --advertise-addr=$SWARM_MANAGER_IP
    else
        echo ":::: Swarm: INIT (master)"
        docker swarm join --token $SWARM_TOKEN \
        --advertise-addr $SWARM_WORKER_IP \
        $SWARM_MANAGER_IP:2237
    fi
else
    echo "#### Swarm INIT or JOIN execution aborded !"
fi
echo $CONSOLE_HL 


########################################################################
# Create overlay network and check network name already exists 
########################################################################

DEFAULT="N"
read -e -p ":::: Create overlay network ? [N/y/q] ": PROCEED
PROCEED="${PROCEED:-${DEFAULT}}"
if [ "${PROCEED}" == "y" ] ; then 
    NET_ACT="create"

    NET_CHECK=$(docker network inspect $NET_NAME --format {{.Name}})

    #### check if network with same name already exixts
    if [ $NET_CHECK == $NET_NAME ]; then
        DEFAULT="N"

        #### ask user what to do: delete and create or abort ? 
        read -e -p ":::: Network $NET_NAME already exists, delete and recreate (y) or abort this step (N) ?": PROCEED
        PROCEED="${PROCEED:-${DEFAULT}}"

        #### if user wants to remove network then create it
        if [ "${PROCEED}" == "y" ] ; then 
            echo ">>>> Docker: Removing network named '$NET_NAME'"
            echo "#### Docker network: $(docker network rm $NET_NAME) removed !" 
            NET_ACT="create"
        #### else user wants to abort process
        else
            NET_ACT="abort"
            echo "#### Network creation aborded !"
        fi
   fi 

   #### if request is create the network
   if [ $NET_ACT == "create" ]; then
       echo ">>>> Docker: Creating overlay network named '$NET_NAME'"
       echo "#### Docker network: $(sudo docker network create -d overlay --attachable --subnet=$APP_SUBNET $NET_NAME)"
   fi

else
    echo "#### Network creation aborded !"
fi

echo $CONSOLE_HL 


########################################################################
# Run 1g_update to create simlinks and copy files to local for first time 
########################################################################

DEFAULT="y"
read -e -p "Run 1g_update program to update files on local ? [N/y/q] ": PROCEED
PROCEED="${PROCEED:-${DEFAULT}}"
if [ "${PROCEED}" == "y" ] ; then 
   echo ">>>> Run 1g_update.sh" 
   /bin/bash $GLOBAL_PATH/1g_update.sh
   echo "#### 0_install.sh execution finished" 
else
   echo "#### 1g_update program running aborded !"
fi
echo $CONSOLE_HL 

