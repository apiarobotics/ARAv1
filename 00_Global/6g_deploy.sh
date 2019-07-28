#!/bin/bash
source config

export $ROS_MASTER_URI
export $NODE_NAME
export $NODE_VERSION

cd catkin_ws/
pwd

source /opt/ros/melodic/setup.bash
catkin_make
source devel/setup.bash

cd src/
pwd
catkin_create_pkg $NODE_NAME std_msgs rospy
mv *.py $NODE_NAME/src/
chmod +x $NODE_NAME/src/.

cd ../
catkin_make install
source devel/setup.bash

cd src/
rosrun $NODE_NAME $ROSRUN_EXE


echo "done"
