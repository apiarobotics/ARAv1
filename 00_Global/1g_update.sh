#!/bin/bash

########################################################################
# Define vars and create local copy of Global file
########################################################################

. ./Local
echo "~~~~ source Local file to get $GLOBAL_PATH"

echo "~~~~ if local file Global already exists then delete it"
if [ -f Global ]; then
    rm -rf Global
fi

echo "~~~~ copy Global file from $GLOBAL_PATH to local folder"
cp ./$GLOBAL_PATH/Global ./
. ./Global

#echo "~~~~ remove first line ($GLOBAL_PATH)"
#tail -n +2 Local > Local.tmp
#
#echo "~~~~ Move temp file to Local"
#mv Local.tmp Local

#while read p; do
#    export $p
#done < Global
#
#while read p; do
#    export $p
#done < Local

#export ROS_MASTER_URI
#export NODE_NAME
#export NODE_VERSION
#export CATKIN
#export DOCKER_RUN
#export DOCKER_CMD

########################################################################
# Intro message 
########################################################################

echo " ***  Updating global files  *** "
echo "#### Source files are into \"$GLOBAL_PATH\" folder"
echo ""


########################################################################
# Creating simlinks and copying files to local 
########################################################################

echo ">>>> Removing obsolete globals"
rm -rf [0-9]g*
rm -rf Dockerfile
echo "#### Obsolete globals removed"
echo ""

echo ">>>> Creating globals simlinks [1-5]"
ln -s ./$GLOBAL_PATH/[1-5]* ./
echo "#### Globals simlinks created"
echo ""

echo ">>>> Copying globals files [6-9]"
cp ./$GLOBAL_PATH/[6-9]* ./
echo "#### Globals files copied"
echo ""

echo ">>>> Creating Dockerfile simlink"
ln -s $GLOBAL_PATH/Dockerfile ./
echo "#### Dockerfile simlink created"
echo ""

chmod +x ./*

ls -la ./


########################################################################
# Run 2g_proceed to run scripts 
########################################################################

/bin/bash ./2g_proceed.sh

