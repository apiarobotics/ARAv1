#!/bin/bash

########################################################################
# Define vars
########################################################################

#while read p; do
#    export $p
#done < Global
#
#while read p; do
#    export $p
#done < Local 

. ./Local
. ./Global

export ROS_MASTER_URI
export NODE_NAME
export NODE_VERSION
export CATKIN
export DOCKER_RUN
export DOCKER_CMD


########################################################################
# Proceeding deployement: execute scripts 7 -> 9 
########################################################################

echo $CONSOLE_BR
echo ":::: Deployement processing (7 -> 9)"
echo $CONSOLE_BR

for i in [7-9][gd]* ; do
    DEFAULT="N"
    read -e -p "Execute: $i ? [N/y/q]:" PROCEED
    PROCEED="${PROCEED:-${DEFAULT}}"
    if [ "${PROCEED}" == "y" ] ; then
        echo $CONSOLE_BR
        echo ">>>> Step $i: Executing"
        echo $CONSOLE_BR
        /bin/bash $i
        echo "#### Step $i: Finished"
        echo $CONSOLE_BR
    else
        echo "#### Execution $i aborded !"
    fi
done

