#!/bin/bash

########################################################################
# Define vars
########################################################################

echo "#### NODE_NAME = $NODE_NAME"
echo "#### NODE_ROLE = $NODE_ROLE"

case "$NODE_ROLE" in
        roscore)
            ########################################################################
            # ROSCORE 
            ########################################################################
            echo ">>>> Starting ROSCORE"
            echo $CONSOLE_BR 
            roscore 
            echo "#### ROSCORE finished"
            echo $CONSOLE_BR 
            ;;

        database)
            ########################################################################
            # DATABASE 
            ########################################################################
            echo ">>>> Starting DATABASE"
            echo $CONSOLE_BR 
            mongod --bind_ip_all
	    #$DB_NAME $DB_CMD
            echo "#### DATABASE finished"
            echo $CONSOLE_BR 
            ;;
        *)
            ########################################################################
            # ROSRUN 
            ########################################################################
            echo ">>>> Starting $NODE_NAME with $ROSRUN_EXE command"
            echo $CONSOLE_BR 
            
            cd catkin_ws/src/
            echo "~~~~ go to $(pwd)"
            echo $CONSOLE_BR 
            
            echo "#### ROS_MASTER_URI = $ROS_MASTER_URI"
            echo $CONSOLE_BR 
            
	    echo "~~~~ execute rosrun (node_name: $NODE_NAME, rosrun_exe: $ROSRUN_EXE)"
	    (set -x; rosrun $ROSPKG_PRE""$NODE_NAME $ROSRUN_EXE)
            echo $CONSOLE_BR 
            
            echo "#### $NODE_NAME finished"
            echo $CONSOLE_BR 
             
            exit 1
esac
    
echo $CONSOLE_BR 
