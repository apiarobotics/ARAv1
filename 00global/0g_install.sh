#!/usr/bin/env bash

#### #### #### #### #### #### #### ####
# DO NOT RUN this program direclty, it must be call by build based on root folder
# IMPORTANT: Nothing has to be setup here, except 2 vars if software binaries structure has changed
#### #### #### #### #### #### #### ####

clear

ROOT_PATH="$(pwd)/"
echo "root_path= "$ROOT_PATH
GLOBAL_PATH="00global/"
echo "global_path= "$GLOBAL_PATH
NETWORK_FILE="Network"
echo "network_file= "$NETWORK_FILE

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~ Autor: Adrien Beaudrey
#~~~~ Version: 0.1
#~~~~ Date: 2019.08.03
#~~~~ Title: Install 
#~~~~ Purpose: Deploy a specific "role" of software for ARA (Apiary Robotic Assistant)
#~~~~ Site: https://apiarobotics.com
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++ PROGRAM FUNCTIONS 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

pushNetwork (){
    #############################
    # Define path to network files:
    # - /etc/hostname
    # - /etc/hosts
    # - /etc/dhcpcd.conf
    #############################
	
    ROLE=$1
    NET_PATH=$2
    
    FILEHOSTNAME=$USBPATH"/etc/hostname"
    FILEHOSTS=$USBPATH"/etc/hosts"
    FILEDHCPCD=$USBPATH"/etc/dhcpcd.conf"	
    
    #############################
    # Deploying host network
    #############################
    
    echo "**** Deploying: Network"
    echo "#### ROLE = "$ROLE
    echo "#### MASTER_ROLE = "$MASTER_ROLE
    echo $CONSOLE_BR
	
    #if [ $ROLE = $MASTER_ROLE ]; then
    #	sudo ssh-keygen -t rsa -b 4096 -f ~/.ssh/master.key -C "master key"
    #fi


    ##
    ##differences beetwen systems (raspbian, ubuntu, ..)
    ##

    
    #### edit FILEHOSTNAME (/etc/hostname)    
    sudo chmod 777 $FILEHOSNAMET
    sudo echo "$ROLE" > $FILEHOSTNAME
    sudo chmod 644 $FILEHOSTNAME
    cat $FILEHOSNAME


    #### edit HOSTS (/etc/hosts)    
    sudo chmod 777 $FILEHOSTS
    sudo echo "127.0.0.1 $ROLE" >> $FILEHOSTS
    sudo echo "" >> $FILEHOSTS
	
    echo "#### Network values from $NET_PATH are: "
    while IFS='' read -r line || [[ -n "$line" ]]; do
		
	    #if line in file starts by ???; then
            echo $v" #### $line"
	    VAR_IP="${line%%=*}"
	    temp="${line%=}"
	    temp2="${temp##*=}"
	    temp3="${temp2%\"}"
	    temp4="${temp3#\"}"
	    VAR_HOST=$temp4
			
	    ((v++))
	    #fi
			
	    sudo echo "$VAR_IP $VAR_HOST" >> $FILEHOSTS 
		
	    #if [ $ROLE = $MASTER_ROLE ]; then
	    #	sudo ssh-copy-id -i ~/.ssh/master.key.pub ubuntu@$VAR_IP
	    #	echo "#### copy certificate on others"
	    #fi
		
    done < "$NET_PATH"
	
    cat $FILEHOSTS
    sudo chmod 644 $FILEHOSTS
    

    #### edit DHCPCD (/etc/dhcpcd.conf)
    sudo chmod 777 $FILEDHCPCD

    echo "" >> $FILEDHCPCD
    echo "interface eth0" >> $FILEDHCPCD
    echo "static ip_address="$ROLE_IP"/24" >> $FILEDHCPCD
    echo "static routers=192.168.0.254" >> $FILEDHCPCD
    echo "static domain_name_servers=192.168.0.254 212.27.40.240 8.8.8.8" >> $FILEDHCPCD 
    sudo chmod 644 $FILEDHCPCD

    cat $FILEDHCPCD
    
    echo $CONSOLE_BR
}


getVars (){
    
    VARS_PATH=$1
    PATTERN=$2 
	
    #############################
    # Getting variables
    ############################# 
	# 3 levels of variables are store inside flat file (00_Global/Global, ./X/Role, ./X/Y/Node)
	
    echo "**** Get Variables from $(pwd) / $VARS_PATH (confirmation pattern = '$PATTERN') :"
    #echo $CONSOLE_BR

    if grep -q $PATTERN $VARS_PATH; then
        # path:
	(set -x; /bin/bash $VARS_PATH)
        
	# read file 
        #echo "#### Param values from $VARS_PATH are: "
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

    else
        echo "!!!!!!!!!! $VARS_PATH file not found, install aborded !"
    fi
}


checkPrereq (){

    #############################
    # Check Docker installation and install Docker if needed
    #############################
    
    echo "**** Checking prerequisites: Docker"
    echo $CONSOLE_BR
    
    if DOCKER_VERSION=$(sudo docker -v); then
        echo "#### $DOCKER_VERSION is already installed: OK"
    else
        echo ">>>> Installing Docker"
        echo $CONSOLE_BR
        sudo apt install curl
        curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
        sudo usermod -aG docker $(whoami)
        echo "#### $(docker -v) installed: OK"
		rm -rf ./get-docker.sh
    fi
    echo $CONSOLE_BR 

}


swarmInstall (){

    #############################
    # Swarm INIT (master) or JOIN (nodes) 
    #############################
    
    echo "**** Deploying: Swarm"
    echo "#### ROLE = "$ROLE
    echo "#### SWARM = "$SWARM
    echo "#### MASTER_ROLE = "$MASTER_ROLE
    echo $CONSOLE_BR

    #### looking for existing Swarm
    SWARM_STATE=$(docker info --format '{{.Swarm.LocalNodeState}}')
	
    if $SWARM_STATE = "inactive"; then
        
	echo "#### Swarm mode has not been detected yet"
        echo $CONSOLE_BR
	
	#### INIT confirmation ? 
	DEFAULT="N"
	echo $CONSOLE_HL 
	read -e -p ":::: INIT new swarm cluster ? [N/y/q] ": PROCEED
	PROCEED="${PROCEED:-${DEFAULT}}"
		
	#### run swarm init 
	if [ "${PROCEED}" == "y" ] ; then 
		echo ">>>> Swarm INIT"
		echo $CONSOLE_BR
		echo "docker swarm init --advertise-addr=$SWARM_MASTER_IP" ## delete echo to activate
		echo $(sudo swarm init --advertise-addr=$SWARM_MASTER_IP)
		#echo $(sudo swarm init)
			
	        #### worked ? 
	        # ---------
			
	else
		echo "#### Swarm INIT aborded !"
	fi
		
    else # Swarm mode cluster: role is other (JOIN)
				
	echo $CONSOLE_HL 
	read -e -p ":::: Please fill the swarm token given at swarm cluster creation step: [q] to abort ": PROCEED
	SWARM_TOKEN=$PROCEED
	#### test token patern
	# ---------

	#### JOIN confirmation ? 
	DEFAULT="N"
	echo $CONSOLE_HL 
	read -e -p ":::: Do you want to JOIN swarm cluster ? [N/y/q] ": PROCEED
	PROCEED="${PROCEED:-${DEFAULT}}"
		
	#### try to join swarm cluster:   
	if [ "${PROCEED}" == "y" ] ; then 		
		echo ">>>> Swarm JOIN with token '$SWARM_TOKEN'"
		echo $CONSOLE_BR
		echo "sudo docker swarm join --token $SWARM_TOKEN $SWARM_MASTER_IP:2237" # delete echo to activate
		#echo "sudo docker swarm join --token $SWARM_TOKEN --advertise-addr $SWARM_WORKER_IP $SWARM_MASTER_IP:2237" # delete echo to activate
		echo $(sudo docker swarm join --token $SWARM_TOKEN $SWARM_MASTER_IP:2237)


		#### worked
	        	
			
		#### if doesn't work:
		# ---------
			
	else
		echo "#### Swarm JOIN aborded !"
	fi
	
    fi
		
}



vnetworkCreate () {

    NET_NAME=$1
    APP_SUBNET=$2
    SWARM=$3

    echo ">>>> Docker: Creating network named '$NET_NAME'"
    echo $CONSOLE_BR
	   
    if $SWARM=$DEP_YES; then
         NET_SWARM = "--d overlay "
    else
	 NET_SWARM = ""
    fi

    if $(set -x(sudo docker network create $NET_SWARM $NET_NAME)); then
	 echo "#### Docker network: $?"
    else
         echo "!!!! Network creation doesn't work !"
    fi
    echo $CONSOLE_BR

}

vnetworkDelete () {
    
    NET_NAME=$1

    echo ">>>> Docker: Removing network named '$NET_NAME'"
    echo $CONSOLE_BR
    echo "#### Docker network: $(sudo docker network rm $NET_NAME) removed !" 
    echo $CONSOLE_BR

}

vnetworkInstall () {
    
    #############################
    # Check existing network
    #############################
   
    NET_NAME=$1
    APP_SUBNET=$2

    # check if network with same name already exixts
    NET_CHECK=$(sudo docker network inspect $NET_NAME --format {{.Name}})

    # if same network already exists: master -> delete / other -> join 
    if [ $NET_CHECK != "" && $NET_CHECK = $NET_ACT ]; then

       echo "#### NET_NAME = $NET_NAME"
       echo "#### NET_CHECK = $NET_CHECK"
       
       DEFAULT=$DEP_VNET_RE
       echo $CONSOLE_HL
       read -e -p ":::: Confirm renew network '$NET_NAME' [$DEP_YES] or [$DEP_QUIT] to quit (Default: $DEP_VNET_RE": PROCEED
       PROCEED="${PROCEED:-${DEFAULT}}"
       
       if [ "${PROCEED}" == "$DEP_YES" ] ; then
           vnetworkDelete $NET_NAME
           vnetworkCreate $NET_NAME $APP_SUBNET $SWARM
       else
           echo "#### Network renewal process aborded !"
       fi 
       echo $CONSOLE_BR
             

    else # if network doesn't exist -> create it
        vnetworkCreate $NET_NAME $APP_SUBNET 
    fi
	
}


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++ RUN GLOBAL (same for all roles)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#############################
# Define GLOBAL vars 
#############################

getVars $ROOT_PATH""$GLOBAL_PATH"Global" "APP_NAME"
echo $CONSOLE_BR 


#############################
# Intro message
#############################

echo " *************************************************** "
echo " ***  Welcome to $APP_NAME:$APP_VERSION installation program  *** "
echo " *************************************************** "
echo "#### please refer to apiarobotics.com to get informed for $APP_NAME updates or new services"
echo $CONSOLE_BR


#############################
# Run checkPrereq function 
#############################

checkPrereq
echo $CONSOLE_BR


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++ SELECT ROLE
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#############################
# List technical roles
#############################
#[1] : Master (Roscore, Logics, Database) 
#[2] : Robot manager (Physics, Structure) 
#[3] : Capture manager (Environment)
#[4] : Bodies manager  
#[5] : Frames manager  
#[6] : Store manager  

#### process: scan current directory for ARA software architecture detection and list all role availables in version package && local config settings.
echo ">>>> Starting scan of roles available to deploy"
echo $CONSOLE_BR

#### scan and construct array to "store" list of role folders.
i=0 #index to array key
declare -a ROLES
for role in [1-9]*; do
	#echo "i = $i , role = $role"
	ROLES[$i]=$role
	((i++))
done

#### once array built print to console
ROLE_NB=${#ROLES[*]}
echo "#### Scan finished, $ROLE_NB roles availables:"
echo $CONSOLE_BR

#### list entries in array "ROLES" and show them to console
j=1 #index
list='' #var to store list of indexes (to remind user available choices)
for role in ${ROLES[*]}; do
	echo "#### [$j] = $role"
#	echo $role 
#	echo ${ROLES[$m]}
	list=$list"[$j] "
	((j++))
done
echo $CONSOLE_BR

#### show request form to select role to deploy (-> start install file hosted in each "role" folder) 
echo $CONSOLE_HL
read -e -p ":::: Choose role to deploy ($list) or [q] to quit": PROCEED
echo $CONSOLE_BR
    
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++ RUN ROLE 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#############################
# Define ROLE vars 
#############################

#### define vars ROLE for next steps
if [[ "$PROCEED" =~ ^[1-6]+$ ]]; then
	n=$(($PROCEED-1))
	#echo "n = $n"
	ROLE=${ROLES[$n]}

	echo "#### your choice is : $ROLE #####"
	echo $CONSOLE_BR 
	
	getVars $ROOT_PATH""$ROLE"/Role" "ROLE_NAME"
	echo $CONSOLE_BR 
fi


#############################
# Deploy host role 
#############################

#### go to "role" folder and run "build" script
if [[ $ROLE ]]; then

	echo ">>>> Starting installer program for $ROLE"
	echo $CONSOLE_BR
	#### go to $ROLE folder:
	cd $ROLE/
	#ROOT_PATH="../$ROOT_PATH"
	echo "#### root_path: $ROOT_PATH"
	echo "#### role_path: $ROLE"
	echo "#### pwd: $(pwd)"
	echo $CONSOLE_BR


	#############################
	# Setup network 
	#############################
	# Network config file is stored in Global folder: /00global/
	
	echo $CONSOLE_HL
	DEFAULT=$DEP_NET
	read -e -p ":::: Setup host network ? [$DEP_YES/$DEP_NO/$DEP_QUIT] (Default: $DEP_NET):" PROCEED
	PROCEED="${PROCEED:-${DEFAULT}}"
	if [ "${PROCEED}" == "$DEP_YES" ] ; then
	    pushNetwork $ROLE $ROOT_PATH""$GLOBAL_PATH""$NETWORK_FILE
	else
	    echo "#### Network setup aborded !"
	fi
	echo $CONSOLE_BR 


	#############################
	# Deploy swarm 
	#############################	
	
	echo $CONSOLE_HL 
	DEFAULT=$DEP_NET
        read -e -p ":::: Deploy swarm ? [N/y/q] ": PROCEED
        PROCEED="${PROCEED:-${DEFAULT}}"
	if [ "${PROCEED}" == "$DEP_YES" ] ; then
	    swarmInstall $ROLE
	else
           echo "#### Swarm deploy aborded !"
        fi
        echo $CONSOLE_BR 


	#############################
	# Install virtual network (Docker) 
	#############################	
	
	echo $CONSOLE_HL 
        DEFAULT=$DEP_VNET
        read -e -p ":::: Install virtual network ? [$DEP_YES/$DEP_NO/$DEP_QUIT] (Default: $DEP_VNET)": PROCEED
        PROCEED="${PROCEED:-${DEFAULT}}"
        if [ "${PROCEED}" == "$DEP_YES" ] ; then 
            vnetworkInstall $NET_NAME $APP_SUBNET
	else
            echo "#### Virtual network install aborded !"
        fi
        echo $CONSOLE_BR 


	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#++++++++++ SCAN NODES (for ROLE selected)
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	#### for each folder (node) inside role root folder: 
	for NODE in [1-9]*; do
	    
	    #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	    #++++++++++ RUN NODE 
	    #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
      	    #echo "+++++++++++ NODE: $NODE +++++++++++"
            #echo $CONSOLE_BR

	    #############################
	    # Define NODE vars 
	    #############################
	   
	    # VARS for NODE are stored in "Node" file include in each node folder for each role 
	    getVars $NODE"/Node" "NODE_NAME"
	    echo $CONSOLE_BR
   
	    # test folder is patern validated:
	    #if [[ "$NODE" =~ [â-zA-Zà-9\ ] ]]; then
	    # yes folder name follows patern

	    DEFAULT=$DEP_ROLE
	    echo $CONSOLE_HL
	    read -e -p ":::: Proceed $NODE installation ? [$DEP_YES/$DEP_NO/$DEP_QUIT] (Default: $DEP_ROLE)": PROCEED 
	    PROCEED="${PROCEED:-${DEFAULT}}"
	    if [ "${PROCEED}" == "$DEP_YES" ] ; then
		echo ">>>> Node $NODE: Installing"
		echo $CONSOLE_BR
		cd $NODE/
		#ROOT_PATH="../$ROOT_PATH"
		echo "#### root_path: $ROOT_PATH"
		echo "#### role_path: $ROLE"
		echo "#### node_path: $NODE"
		echo "#### pwd: $(pwd)"
		echo $CONSOLE_BR
		
		#echo "ROSRUN_EXE=$ROSRUN_EXE"
		#echo $CONSOLE_BR
				
		#############################
		# Run 1g_update to create simlinks and copy files to local for first time 
		#############################
				
		DEFAULT=$DEP_NODE
		echo $CONSOLE_HL
		read -e -p ":::: Run 1g_update program to update files in node directory ($NODE) ? [$DEP_YES/$DEP_NO/$DEP_QUIT] (Default: $DEP_NODE)": PROCEED
		PROCEED="${PROCEED:-${DEFAULT}}"
		if [ "${PROCEED}" == "$DEP_YES" ] ; then 
		   echo ">>>> Run 1g_update.sh" 
		   echo $CONSOLE_BR 

		   source $ROOT_PATH""$GLOBAL_PATH"/1g_update.sh"

		   echo "#### 0_install.sh execution finished" 
	        else
		   echo "#### 1g_update program running aborded !"
		fi
		echo $CONSOLE_BR 


		#############################
		# Finishing program  
		#############################


		echo "#### Node $NODE: Installation done"
	    else
		echo "#### Installation $NODE aborded !"
	    fi
	    echo $CONSOLE_BR 
	    #fi
        done

else
        echo "#### invalid entry, please relaunch program after terminating"
        echo $CONSOLE_BR
fi
