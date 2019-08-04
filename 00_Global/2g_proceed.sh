#!/bin/bash

########################################################################
# Define vars
########################################################################

#. ./Local
#. ./Global


########################################################################
# Proceeding installation: execute scripts 3 -> 5 
########################################################################

echo ":::: Execution processing (3 -> 5)"

for i in [3-5][gd]* ; do
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
