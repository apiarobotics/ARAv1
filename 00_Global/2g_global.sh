#!/bin/bash
source config

while read p; do
    export $p
done <config 

echo "#### Config vars ####"
echo "## node_name = " $NODE_NAME
echo "## node_version = " $NODE_VERSION
echo "#### ##### ####  ####"
echo ""
