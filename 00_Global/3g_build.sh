#!/bin/bash
. ./config

echo "~~~~ docker build starts ~~~~"
echo "node_name = $NODE_NAME , node_version = $NODE_VERSION"
echo ""

sudo docker build -t arav1/$NODE_NAME:$NODE_VERSION -f Dockerfile .

echo "~~~~ docker build ends ~~~~"
echo ""
