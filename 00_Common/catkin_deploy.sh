#!/bin/bash

NODE_NAME=source node_name

cd ~/catkin_ws/src
catkin_create_pkg $NODE_NAME std_msgs rospy

mv ~/catkin_ws/src/*.py ~/catkin_ws/src/$NODE_NAME/src/

echo 'export ROS_MASTER_URI="http://172.18.0.2:11311/"' >> ~/.bashrc
echo 'source ~/catkin_ws/devel/setup.bash' >> ~/.bashrc
