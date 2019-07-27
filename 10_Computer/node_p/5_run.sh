#!/bin/bash

#sudo docker run -it --rm --net ara --name node_p arav1/node_p:0.1 bash

sudo docker run -it --rm --net ara --name node_p -v /~/ARAv1/00_Common:/root/ara_run_scripts/: arav1/node_p:0.1 bash
