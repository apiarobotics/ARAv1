#!/bin/bash

###
# Define vars
###

#. ./Local
#. ./Global


###
# Proceeding installation: execute scripts 3 -> 5 
###

echo ": Execution processing (3 -> 5)"

for i in [3-5][gd]* ; do
    DEFAULT=$DEP_NODE
	echo $CONSOLE_HL
    read -e -p "Execute: $i ? [$DEP_YES/$DEP_NO/$DEP_QUIT] (Default: $DEP_NODE):" PROCEED
    PROCEED="${PROCEED:-${DEFAULT}}"
    if [ "${PROCEED}" == "$DEP_YES" ] ; then
        echo "> Step $i: Executing"
		echo $CONSOLE_BR
        /bin/bash $i
        echo "# Step $i: Finished"
    else
        echo "# Execution $i aborded !"
    fi
    echo $CONSOLE_BR
done
