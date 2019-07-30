#!/bin/bash

########################################################################
# Define vars
########################################################################

. ./Local
. ./Global


########################################################################
# Proceeding deployement: execute scripts 7 -> 9 
########################################################################

echo ":::: Deployement processing (7 -> 9)"

for i in [7-9][gd]* ; do
    DEFAULT="N"
    read -e -p "Execute: $i ? [N/y/q]:" PROCEED
    PROCEED="${PROCEED:-${DEFAULT}}"
    if [ "${PROCEED}" == "y" ] ; then
        echo ">>>> Step $i: Executing"
        /bin/bash $i
        echo "#### Step $i: Finished"
    else
        echo "#### Execution $i aborded !"
    fi
    echo $CONSOLE_HL
done

