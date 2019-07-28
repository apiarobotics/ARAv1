#!/bin/bash

GLOBAL_PATH="../../00_Global"

D
echo " ***  Updating global files  *** "
echo "#### Source files are into \"$GLOBAL_PATH\" folder"
echo ""

echo ">>>> Removing obsolete global simlinks"
rm -rf [0-9]g*
#rm -rf Dockerfile
echo "#### Obsolete global simlinks removed"
echo ""

echo ">>>> Creating global simlinks [0-5]"
ln -s $GLOBAL_PATH/[0-5][g]* ./
echo "#### Global simlinks created"
echo ""

echo ">>>> Copying global files [6-9]"
cp $GLOBAL_PATH/[6-9][g]* ./
echo "#### Global files copied"
echo ""

echo ">>>> Creating Dockerfile simlink"
ln -s $GLOBAL_PATH/Dockerfile ./
echo "#### Dockerfile simlink created"
echo ""

echo ">>>> Creating update.sh simlink"
ln -s $GLOBAL_PATH/update.sh ./ 
echo "#### update.sh simlink created"
echo ""

chmod +x ./*

ls -la ./
