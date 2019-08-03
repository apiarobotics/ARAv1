#!/bin/bash

########################################################################
# Define vars
########################################################################

echo "CATKIN = $CATKIN"

if [ "$CATKIN" ==  "Yes" ]; then
    
    echo ":::: Deploy application with Catkin"
    echo $CONSOLE_BR
    
    ########################################################################
    # Deploy app 
    ########################################################################
    
    echo $CONSOLE_BR
    echo ">>>> Starting $NODE_NAME deploy process"
    
    echo "~~~~ source ROS opt/ros/melodic/setup.bash"
    source /opt/ros/melodic/setup.bash
    
    cd catkin_ws/
    echo "~~~~ go to $(pwd)"
    
    echo "~~~~ run ROS catkin_make"
    catkin_make
    
    echo "~~~~ source ROS devel/setup.bash"
    source devel/setup.bash
    
        cd src/
        echo "~~~~ go to $(pwd)"
        
        echo "~~~~ create ROS package: $NODE_NAME"
        catkin_create_pkg $NODE_NAME std_msgs rospy
        echo "~~~~ go to $(pwd)"
        
        echo "~~~~ move .py source files to new node src folder: $NODE_NAME/src/"
        cd $NODE_NAME/src
        echo "~~~~ go to $(pwd)"
        mv ../../*.py ./
        
        echo "~~~~ make src files executable mod in folder: /root/catkin_ws/src/$NODE_NAME/src/"
        chmod +x ./*
        echo "~~~~ show files in dir: $(pwd)"
        ls -la ./ 
        echo "~~~~ ~~~~ ~~~~"
        
        cd ../../../
        echo "~~~~ go to $(pwd)"
        
        echo "~~~~ run ROS catkin_make install"
        catkin_make install
        
        echo "~~~~ source ROS devel/setup.bash"
        source devel/setup.bash

else
    echo "#### No catkin pak to deploy"
fi        

echo $CONSOLE_BR
echo "#### Application $NODE_NAME deploy processing finished"


