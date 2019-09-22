#!/bin/bash

###
# Define vars
###

. ./Local
. ./Global

echo "ROS_MASTER_URI = $ROS_MASTER_URI"
export ROS_MASTER_URI="$ROS_MASTER_URI"
echo "NODE_ROLE = $NODE_ROLE"

case "$NODE_ROLE" in
        master)
            
            ###
            # ROSRUN: Run ROSCORE 
            ###
            
            echo "> Starting ROSCORE"
            roscore 
            echo "# ROSCORE finished"

            ;;
        *)

            ###
            # ROSRUN: Run app
            ###
            
            echo "> Starting $NODE_NAME with $ROSRUN_EXE command"
            
            cd catkin_ws/src/
            echo "~~~~ go to $(pwd)"
            
            echo "~~~~ execute rosrun (node_name: $NODE_NAME, rosrun_exe: $ROSRUN_EXE)"
            rosrun $NODE_NAME $ROSRUN_EXE
            
            echo "# $NODE_NAME finished"
             
            exit 1
esac
    
echo $CONSOLE_HL 
