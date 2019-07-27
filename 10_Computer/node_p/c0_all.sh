#!/bin/bash

echo "###### run c1 ######"
/bin/bash c1_commons.sh
echo ""

echo "###### run u3 ######"
/bin/bash u3_build.sh
echo ""

echo "###### run c3 ######"
/bin/bash c3_build.sh
echo ""

echo "###### run u5 ######"
/bin/bash u5_run.sh
echo ""

echo "###### run c5 ######"
/bin/bash c5_run.sh
echo ""
