FROM ros:melodic-ros-base

RUN apt-get update && apt-get install locales
RUN locale-gen fr_FR.UTF-8
ENV LANG fr_FR.UTF-8

RUN apt-get update && apt-get install -y \
    && rm -rf /var/likb/apt/lists/*

COPY catkin_ws /root/
WORKDIR /root/catkin_ws
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; catkin_make'
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; source devel/setup.bash'
