#!/bin/bash

########################################################################
# Define vars
########################################################################

. ./Local
. ./$GLOBAL_PATH/Global


########################################################################
# Proceeding installation: execute scripts 3 -> 5 
########################################################################

echo ""
echo $CONSOLE_BR
echo ":::: Execution processing (3 -> 5)"
echo $CONSOLE_BR

for i in [3-5][gd]* ; do
    DEFAULT="N"
    read -e -p "Execute: $i ? [N/y/q]:" PROCEED
    PROCEED="${PROCEED:-${DEFAULT}}"
    if [ "${PROCEED}" == "y" ] ; then
        echo $CONSOLE_BR
        echo ">>>> Step $i: Executing"
        echo $CONSOLE_BR
        /bin/bash $i
        echo "#### Step $i: Finished"
        echo $CONSOLE_BR
    else
        echo "#### Execution $i aborded !"
    fi
done
