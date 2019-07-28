#!/bin/bash
source config

echo "~~~~~~~ Config vars:"
echo "node_name = " $NODE_NAME
echo "node_version = " $NODE_VERSION
echo "~~~~~~~~~~~~~~~~~~~~"

while read p; do
    export $p
done <config 

chmod +x ./*
#ls -la ./
