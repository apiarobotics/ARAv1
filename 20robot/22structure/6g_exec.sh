#!/bin/bash


getVars () {

    	VARS_PATH=$1

	while IFS='' read -r line || [[ -n "$line" ]]; do
            echo "#### $line"
            VAR_NAME="${line%%=*}"
	    temp="${line%=}"
	    temp2="${temp##*=}"
	    temp3="${temp2%\"}"
	    temp4="${temp3#\"}"
	    VAR_DATA=$temp4
	    export $VAR_NAME="$VAR_DATA"
	    #echo $VAR_NAME"="$VAR_DATA

        done < "$VARS_PATH"

}


########################################################################
# Define vars
########################################################################

getVars "./Global"
getVars "./Role"
getVars "./Node"

source /ros_entrypoint.sh

########################################################################
# Proceeding deployement: execute scripts 7 -> 9 
########################################################################

echo ":::: Deployement processing (7 -> 9)"

for i in [7-9][gd]* ; do
#    DEFAULT="N"
#    echo $CONSOLE_HL
#    read -e -p ":::: Execute: $i ? [N/y/q]:" PROCEED
#    PROCEED="${PROCEED:-${DEFAULT}}"
#    if [ "${PROCEED}" == "y" ] ; then
        echo ">>>> Step $i: Executing"
        /bin/bash $i
        echo "#### Step $i: Finished"
#    else
#        echo "#### Execution $i aborded !"
#    fi
    echo $CONSOLE_BR
done

