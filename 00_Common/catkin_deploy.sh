#!/bin/bash

export ROS_MASTER_URI="http://172.18.0.2:11311/"

#read -p "Enter pkg name: " pkg_name
cd ~/catkin_ws/src
catkin_create_pkg $NODE_NAME std_msgs rospy
cd ~/catkin_ws
#catkin_make
/bin/bash ~/catkin_ws/devel/setup.bash

mv ~/catkin_ws/src/*.py ~/catkin_ws/src/$NODE_NAME/src/
