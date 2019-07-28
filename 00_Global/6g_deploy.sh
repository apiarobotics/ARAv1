#!/bin/bash

export ROS_MASTER_URI="http://172.18.0.2:11311/"
export NODE_NAME=$(cat node_name)
export NODE_VERSION=$(cat node_version)

cd catkin_ws

source /opt/ros/melodic/setup.bash
catkin_make
source devel/setup.bash

cd src
catkin_create_pkg $NODE_NAME std_msgs rospy

mv *.py $NODE_NAME/src/
chmod +x $NODE_NAME/src/.
