#!/bin/bash

export NODE_NAME=$(cat node_name)
export NODE_VERSION=$(cat node_version)

#sudo docker run -it --rm --net ara -w /root --entrypoint=6g_deploy.sh --name node_p arav1/node_p:0.1 /bin/bash

sudo docker run -it --rm --net ara -w /root --name $NODE_NAME arav1/$NODE_NAME:$NODE_VERSION /bin/bash
