#!/bin/bash

########################################################################
# Define vars
########################################################################

. ./Local
. ./$GLOBAL_PATH/Global


########################################################################
# Remove and copy Global file to able to use global variables inside container
########################################################################

echo ""
echo ">>>> Starting removing and copying Global file"
echo ""
rm -rf Global
cp $GLOBAL_PATH/Global ./
echo "#### Global file copied" 
echo ""

########################################################################
# Run Docker build 
########################################################################
echo ""
echo ">>>> Starting Docker build"
echo "#### node_name = $NODE_NAME"
echo "#### node_version = $NODE_VERSION"
echo ""

sudo docker build -t arav1/$NODE_NAME:$NODE_VERSION -f Dockerfile .

echo "#### Docker build finished"
echo ""
