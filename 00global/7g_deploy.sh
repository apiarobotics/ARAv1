#!/bin/bash

###
# Define vars
###

#. ./Local
#. ./Global

###
# Deploy network facilities 
###

#add 10master host in /etc/hosts file to enable ROS communication

#$ROSCORE


###
# Deploy app 
###

#echo "CATKIN = $CATKIN"

if [ "$CATKIN" ==  "Yes" ]; then
    
    echo ": Deploy application with Catkin"
        echo $CONSOLE_BR
    
	echo "> Starting ($ROSPKG_PRE)$NODE_NAME deploy process"
        echo $CONSOLE_BR
    
    echo "~~~~ source ROS opt/ros/melodic/setup.bash"
    source /opt/ros/melodic/setup.bash
    
    cd catkin_ws/
    echo "~~~~ go to $(pwd)"
    
    echo "~~~~ run ROS catkin_make"
    catkin_make
    
    echo "~~~~ source ROS devel/setup.bash"
    source devel/setup.bash
    
    cd src/
    echo "~~~~ go to $(pwd)"
        
    echo "~~~~ create ROS package: $ROSPKG_PRE""$NODE_NAME"
    catkin_create_pkg $ROSPKG_PRE""$NODE_NAME std_msgs rospy
    echo "~~~~ go to $(pwd)"
        
    echo "~~~~ move .py source files to new node src folder: $ROSPKG_PRE""$NODE_NAME/src/"
    cd $ROSPKG_PRE""$NODE_NAME/src
    echo "~~~~ go to $(pwd)"
    mv ../../*.py ./
        
    echo "~~~~ make src files executable mod in folder: /root/catkin_ws/src/$ROSPKG_PRE""$NODE_NAME/src/"
    chmod +x ./*
    echo "~~~~ show files in dir: $(pwd)"
    ls -la ./ 
    echo $CONSOLE_BR
        
    cd ../../../
    echo "~~~~ go to $(pwd)"
        
    echo "~~~~ run ROS catkin_make install"
    catkin_make install
        
    echo "~~~~ source ROS devel/setup.bash"
    source devel/setup.bash

else
    echo "# No catkin pack to deploy"
fi        
echo $CONSOLE_BR

echo "# Application ($ROSPKG_PRE)$NODE_NAME deploy processing finished"
echo $CONSOLE_BR

