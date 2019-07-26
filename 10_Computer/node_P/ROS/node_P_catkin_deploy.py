#!/bin/bash

source /opt/ros/melodic/setup.bash

cd /root/

mkdir ARA_ROBOT/src

cp -r /root/ARA_ROBOT_SRC/ ./

cd /root/ARA_ROBOT/src

catkin_init_workspace
