#!/bin/bash

###
# Define vars and create local copy of Global file
###

#. ./Local
#echo "~~~~ source Local file to get $GLOBAL_PATH"
#
#echo "~~~~ if local file Global already exists then delete it"
#if [ -f Global ]; then
#    rm -rf Global
#fi
#
#echo "~~~~ copy Global file from $GLOBAL_PATH to local folder"
#cp ./$GLOBAL_PATH/Global ./
#. ./Global


###
# Intro message 
###

echo ": Updating global files process"
echo "# Source files are hosted inside \"$GLOBAL_PATH\" folder"
echo $CONSOLE_HL


###
# Remove and copy Global file to able to use global variables inside container
###

echo "> Starting removing and copying global.conf file"
rm -rf global.conf
cp $ROOT_PATH""$GLOBAL_PATH"global.conf" ./
echo "# global.conf file copied (from $ROOT_PATH""$GLOBAL_PATH to $(pwd))"
echo $CONSOLE_HL

###
# Remove and copy Role file to able to use role variables inside container
###

echo "> Starting removing and copying Role file"
rm -rf role.conf
cp ../role.conf ./
echo "# role.conf file copied (from $ROLE to $(pwd))"
echo $CONSOLE_HL


###
# Creating simlinks and copying files to local 
###

echo "> Removing obsolete globals"
rm -rf [0-9]g*
#rm -rf Dockerfile
rm -rf Dockerfile*
echo "# Obsolete globals removed"

echo "> Creating globals simlinks [1-5]"
ln -s $ROOT_PATH""$GLOBAL_PATH[1-5]* ./
echo "# Globals simlinks created"

echo "> Copying globals files [6-9]"
cp $ROOT_PATH""$GLOBAL_PATH[6-9]* ./
echo "# Globals files copied"

echo "> Creating Dockerfile simlink"
#ln -s $ROOT_PATH""$GLOBAL_PATH"Dockerfile" ./
ln -s $ROOT_PATH""$GLOBAL_PATH"Dockerfile"* ./
echo "# Dockerfile simlink created"

chmod +x ./*

ls -la ./

echo $CONSOLE_HL


###
# Run 2g_proceed to run scripts 
###

/bin/bash $ROOT_PATH""$GLOBAL_PATH"2g_proceed.sh"

