#!/bin/bash

getRoles () {
    list=''
    
    for role in ../[1-9]*; do
        echo "role="$role 
        list=$list""$role
    done
    export $list

}

prepare () {

    CURRENTROLE=$1
    
    source Global
    source ../$CURRENTROLE/Role


    USBPATH=/media/$(whoami)/rootfs
    FILEHOSTNAME=$USBPATH"/etc/hostname"
    FILEHOSTS=$USBPATH"/etc/hosts"
    FILEDHCPCD=$USBPATH"/etc/dhcpcd.conf"

    sudo chmod 777 $FILEHOSTNAME
    sudo chmod 777 $FILEHOSTS
    sudo chmod 777 $FILEDHCPCD

    sudo echo $HOSTNAME > $FILEHOSTNAME"

    sudo echo "127.0.0.1 "$HOSTNAME >> $FILEHOSTS

    
    for role in [1-9]*; do
        source $role"/"Role
        
        echo $ROLE_NAME" "$ROLE_IP >>  $FILEHOSTS

    done

    echo "interface eth0" >> $FILEDHCPCD
    echo "static ip_address="$ROLE_IP"/24" >> $FILEDHCPCD
    echo "static routers="192.168.0.254" >> $FILEDHCPCD
    echo "static domain_name_servers="192.168.0.254" >> $FILEDHCPCD


    sudo chmod 644 $FILEHOSTNAME
    sudo chmod 644 $FILEHOSTS
    sudo chmod 644 $FILEDHCPCD
}

getRoles

DEFAULT="q"

read -e -p "Role list: $list or [q] to quit": PROCEED

PROCEED="${PROCEED:-${DEFAULT}}"


if [[ "${PROCEED}" =~ ^[1-6]+$ ]]; then
	
    prepare $PROCEED 

fi


