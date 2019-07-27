#!/bin/bash

sudo docker run --privileged -it --rm --net ara -e NODE_NAME=node_capture --name node_capture arav1/node_capture:0.1 bash
