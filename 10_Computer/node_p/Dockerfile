FROM ros:melodic-ros-base

RUN apt-get update && apt-get install locales
RUN locale-gen fr_FR.UTF-8
ENV LANG fr_FR.UTF-8

RUN apt-get install -y net-tools iputils-ping\
    && rm -rf /var/likb/apt/lists/*

WORKDIR /root
ADD ./ /root

