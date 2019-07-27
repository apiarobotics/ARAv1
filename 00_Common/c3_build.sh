#!/bin/bash

echo "docker build : node_name = $NODE_NAME , node_version = $NODE_VERSION"
echo ""

sudo docker build -t arav1/$NODE_NAME:$NODE_VERSION .

echo "docker build ends"
echo ""
