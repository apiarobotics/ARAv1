#!/bin/bash

echo "###### run 2g: Global /copy ######"
/bin/bash 2g_global.sh
echo ""

echo "###### run 3d: Dedicated /build ######"
/bin/bash 3d_build.sh
echo ""

echo "###### run 3g: Global /build ######"
/bin/bash 3g_build.sh
echo ""

echo "###### run 5d: Dedicated /run ######"
/bin/bash 5d_run.sh
echo ""

echo "###### run 5g: Global /run ######"
/bin/bash 5g_run.sh
echo ""
