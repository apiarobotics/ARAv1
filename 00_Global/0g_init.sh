#!/bin/bash
source config

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Execution process starting"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

for i in [1-5][gd]*; do
    echo "- --- ----- ------- ------------- "
    echo "Step $i:"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    /bin/bash $i
    echo "---------- --------- ------ --- - "
    echo ""
done

