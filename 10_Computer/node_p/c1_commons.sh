#!/bin/bash

echo "copy all commons files to node directory:"
echo ""

cp -r ../../00_Common/. ./
ls -la ./

export NODE_NAME=$(cat node_name)
echo "node name:" $NODE_NAME

export NODE_VERSION=$(cat node_version)
echo "node version:" $NODE_VERSION

echo "copy commons ends"
echo ""
