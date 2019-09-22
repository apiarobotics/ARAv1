#!/bin/bash

###
# Define vars
###

#. ./Local
#. ./Global


###
# Run Docker build 
###

echo "> Starting Docker build"
echo $CONSOLE_BR
echo "# REPO_NAME=$REPO_NAME"
echo "# NODE_NAME=$NODE_NAME"
echo "# NODE_VERSION=$NODE_VERSION"
echo "# DOCKERFILE=$DOCKERFILE"
 

sudo docker build -t $REPO_NAME"/"$NODE_NAME":"$NODE_VERSION -f $DOCKERFILE .

echo "# Docker build finished"
echo $CONSOLE_BR 
