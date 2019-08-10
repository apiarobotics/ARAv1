#!/bin/bash

sudo docker run -e ROS_MASTER_URI=http://192.168.0.81:11311/ -it --rm -v "/home/pi/ARAv1/20robot/22structure/:/root/hostFolder" --device=/dev/ttyACM0 --net ara_ntw -w /root --name 22structure --hostname 22structure arav1/22structure:0.1 /bin/bash

