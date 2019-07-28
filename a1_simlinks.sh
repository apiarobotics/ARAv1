#!/bin/bash

APP_NAME=ara

#create simlinks for global files
SRC_PATH="../../00_Global"
echo "\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/¨\/"
echo "Create simlinks for Globals ([1-5][g])"
echo "/\_/\_/\_/\_/\_/\_/\_/\_/\_/\"
for f in $SRC_PATH/[1-5][g]*; do
    ln -s $SRC_PATH/$f ./ 
done
