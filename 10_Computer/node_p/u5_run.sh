#!/bin/bash

sudo docker run -it --rm --net ara -e NODE_NAME=node_p -w /root --name node_p arav1/node_p:0.1 /bin/bash 

