FROM ros:melodic-ros-base

ENV NODE_NAME="node_p"

RUN apt-get update && apt-get install locales
RUN locale-gen fr_FR.UTF-8
ENV LANG fr_FR.UTF-8

RUN apt-get install -y net-tools iputils-ping\
    && rm -rf /var/likb/apt/lists/*

RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws/src
ADD catkin_ws/src/ /root/catkin_ws/src
RUN ls -la

WORKDIR /root
ADD node_name /root
ADD scripts /root
RUN ls -la

WORKDIR /root/catkin_ws
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; catkin_make'
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; source devel/setup.bash'

WORKDIR /root
RUN sh catkin_deploy.sh


