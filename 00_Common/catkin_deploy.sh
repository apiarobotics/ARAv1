#!/bin/bash

read -p "Enter pkg name: " pkg_name
cd ~/catkin_ws/src
catkin_create_pkg pkg_name std_mgsg rospy
cd ../
catkin_make
source devel/setup.bash
