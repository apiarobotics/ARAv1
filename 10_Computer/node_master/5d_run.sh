#!/bin/bash
source config

#sudo docker run -it --rm --net ara -w /root --entrypoint=6g_deploy.sh --name node_p arav1/node_p:0.1 /bin/bash

sudo docker run -it --rm --net ara -w /root --name $NODE_NAME arav1/$NODE_NAME:$NODE_VERSION $ROSRUN_EXE 
