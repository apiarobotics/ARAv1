#!/bin/bash

sudo docker run -it --rm --net ara --name node_master arav1/node_master:0.1 roscore
