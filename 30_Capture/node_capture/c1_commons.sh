#!/bin/bash

#copy all commons files to node directory
cp -r ../../00_Common/. ./

export NODE_NAME=$(cat node_name)
echo $NODE_NAME

export NODE_VERSION=$(cat node_version)
echo $NODE_VERSION
