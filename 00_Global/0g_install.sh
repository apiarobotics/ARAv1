#!/usr/bin/env bash

#### #### #### #### #### #### #### ####
# DO NOT RUN this program direclty, it must be call by build based on root folder
# IMPORTANT: Nothing has to be setup here, except 2 vars if software binaries structure has changed
ROOT_PATH="./"
GLOBAL_PATH="00_Global/"
#### #### #### #### #### #### #### ####

clear

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~ 
#~~~~ 
#~~~~ Autor: Adrien Beaudrey
#~~~~ 
#~~~~ Version: 0.1
#~~~~ 
#~~~~ Date: 2019.08.03
#~~~~ 
#~~~~ Title: Install 
#~~~~ 
#~~~~ Purpose: Deploy a specific "role" of software for ARA (Apiary Robotic Assistant)
#~~~~ 
#~~~~ Site: https://apiarobotics.com
#~~~~ 
#~~~~ 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++ PROGRAM FUNCTIONS 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

pushNetwork (){
	
	ROLE=$1
	NET_PATH=$2
	
	#test network
	
	if $(hostname) 
	
	#test cert
	
	sudo ssh-keygen -t rsa -b 4096 -f ~/.ssh/master.key -C "master key"
	
	sudo chmod 777 /etc/hosts
	sudo echo "127.0.0.1 $ROLE" >> /etc/hosts
	
	v=0
	echo "#### Network values from $NET_PATH are: "
	while IFS='' read -r line || [[ -n "$line" ]]; do
		if $v != 0; then
		
			#if line in file starts by ???; then
			echo "#### $line"
			VAR_IP="${line%%=*}"
			temp="${line%=}"
			temp2="${temp##*=}"
			temp3="${temp2%\"}"
			temp4="${temp3#\"}"
			VAR_HOST=$temp4
			((v++))
			#fi
			
			sudo echo "$VAR_IP $VAR_HOST" >> /etc/hosts
			
			#sudo ssh-copy-id -i ~/.ssh/master.key.pub ubuntu@$VAR_IP
		fi		
		
	done < "$NET_PATH"
	
	cat /etc/hosts
	sudo chmod 644 /etc/hosts
	echo $CONSOLE_BR
}

getVars (){
    # 3 levels of variables are store inside flat file (00_Global/Global, ./X/Role, ./X/Y/Node)
    
    VARS_PATH=$1
    PATTERN=$2 
    
    echo "**** Get Variables from $(pwd) / $VARS_PATH ($PATTERN)"
    echo $CONSOLE_BR

    if grep -q $PATTERN $VARS_PATH; then
        # path:
        /bin/bash $VARS_PATH
        
	# read file 
        echo "#### Param values from $VARS_PATH are: "
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
# run all prerequistes on start: docker, docker-swarm, docker-network


    #############################
    # Check Docker installation and install Docker if needed
    #############################
    
    echo "**** Checking prerequisites: Docker"
    echo $CONSOLE_BR
    
    #echo "dpkg command: $(dpkg -l | grep docker-ce)"
    #echo $(dpkg -l | grep docker-ce >/dev/null)
    #echo $(dpkg -l | grep docker-ce >/dev/null)
    #command -v docker >/dev/null
    
    #if [ $? -eq 0 ] ; then
    #    echo "#### $(docker -v) is already installed: OK"
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
    
    echo "**** Swarm: INIT or JOIN"
    echo $CONSOLE_BR 
    
    #### Swarm mode cluster role selection
	
    
    DEFAULT="N"
    #read -e -p ":::: INIT or JOIN swarm cluster ? [N/y/q] ": PROCEED
    echo $CONSOLE_HL 
    read -e -p ":::: Do you want to JOIN an existing swarm cluster ? [N/y/q] ": PROCEED
    PROCEED="${PROCEED:-${DEFAULT}}"
    
    if [ "${PROCEED}" == "y" ] ; then 
	
		echo "ROLE = "$ROLE
		
		if $ROLE = "master"; then
			
			#### init new ? 
			# ---------
			DEFAULT="N"
			echo $CONSOLE_HL 
			read -e -p ":::: Do you want to INIT new swarm cluster ? [N/y/q] ": PROCEED
			PROCEED="${PROCEED:-${DEFAULT}}"
			
			#### run swarm init 
			# ---------
			if [ "${PROCEED}" == "y" ] ; then 
				echo ">>>> Swarm: INIT (master)"
				echo $CONSOLE_BR
				docker swarm init --advertise-addr=$SWARM_MANAGER_IP
			else
				echo "#### Swarm execution aborded !"
			fi
		
			#### worked ? 
			# ---------
		
		else
		
			echo $CONSOLE_HL 
			read -e -p ":::: Please fill the swarm token given at swarm cluster creation step: [q] to abort ": PROCEED
			SWARM_TOKEN=$PROCEED
			#### test token patern
			# ---------
			# ---------
			# ---------
			# ---------
			# ---------
			# ---------
		
			#### try to join swarm cluster:    
			echo ">>>> Swarm: JOIN Swarm with token '$SWARM_TOKEN'"
			echo $CONSOLE_BR
			docker swarm join --token $SWARM_TOKEN \
			--advertise-addr $SWARM_WORKER_IP \
			$SWARM_MANAGER_IP:2237
		
			#### if doesn't work:
			# ---------
			
		fi
		
    else
        echo "#### Swarm execution aborded !"
    fi
    echo $CONSOLE_BR 
}


vnetworkInstall () {
    
    #############################
    # Create overlay network and check network name already exists 
    #############################
    
    DEFAULT="N"
    echo $CONSOLE_HL 
    read -e -p ":::: Create overlay network ? [N/y/q] ": PROCEED
    PROCEED="${PROCEED:-${DEFAULT}}"
    if [ "${PROCEED}" == "y" ] ; then 
        NET_ACT="create"
    
        NET_CHECK=$(docker network inspect $NET_NAME --format {{.Name}})
    
        #### check if network with same name already exixts
        if [ $NET_CHECK == $NET_NAME ]; then
            DEFAULT="N"
    
            #### ask user what to do: delete and create or abort ? 
            echo $CONSOLE_HL 
            read -e -p ":::: Network $NET_NAME already exists, delete and recreate (y) or abort this step (N) ?": PROCEED
            PROCEED="${PROCEED:-${DEFAULT}}"
    
            #### if user wants to remove network then create it
            if [ "${PROCEED}" == "y" ] ; then 
                echo ">>>> Docker: Removing network named '$NET_NAME'"
                echo $CONSOLE_BR
                echo "#### Docker network: $(docker network rm $NET_NAME) removed !" 
                echo $CONSOLE_BR
                NET_ACT="create"
            #### else user wants to abort process
            else
                NET_ACT="abort"
                echo "#### Network creation aborded !"
                echo $CONSOLE_BR
            fi
       fi 
    
       #### if request is create the network
       if [ $NET_ACT == "create" ]; then
           echo ">>>> Docker: Creating overlay network named '$NET_NAME'"
           echo $CONSOLE_BR
           
	   if $(sudo docker network create -d overlay --attachable --subnet=$APP_SUBNET $NET_NAME); then
               echo "#### Docker network: $?"
           else
               echo "!!!! Network not working !"
           fi
           echo $CONSOLE_BR
       fi
    
    else
        echo "#### Network creation aborded !"
    fi
    
    echo $CONSOLE_BR 


}




#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++ RUN GLOBAL 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#############################
# Intro message
#############################

echo " *************************************************** "
echo " ***  Welcome to $APP_NAME:$APP_VERSION installation program  *** "
echo " *************************************************** "
echo "#### please refer to apiarobotics.com to get informed for $APP_NAME updates or new services"
echo $CONSOLE_BR


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++ CHECK PREREQUISITES
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#############################
# Define GLOBAL vars 
#############################

getVars $ROOT_PATH""$GLOBAL_PATH"Global" "APP_NAME"
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
#[1] : Master (Master=roscore Logics, Database) 
#[2] : Robot manager (Physics, Robot) 
#[3] : Capture manager 
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
DEFAULT="q"
echo $CONSOLE_HL
read -e -p ":::: Choose role to deploy ($list) or [q] to quit": PROCEED
PROCEED="${PROCEED:-${DEFAULT}}"

    
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
	
	getVars $ROOT_PATH""$ROLE"/Role" "ROLE_NAME"
	echo $CONSOLE_BR 
fi


#############################
# Deploy host role 
#############################

#### go to "role" folder and run "build" script
if [[ $ROLE ]]; then

	echo ">>>> Starting installer program"
	echo $CONSOLE_BR
	echo "+++++++++++ ROLE: $ROLE +++++++++++"
	#### go to $ROLE folder:
	cd $ROLE/
	ROOT_PATH="../$ROOT_PATH"
	echo "#### pwd: $(pwd)"
	echo "#### root_path: $ROOT_PATH"
	echo $CONSOLE_BR
	
	#############################
	# Configure host network 
	#############################
	# Network config file is stored in Global folder: /00_Global/
	
	pushNetwork $ROLE $ROOT_PATH""$GLOBAL_PATH""Network
	

	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#++++++++++ RUN NODE 
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	#### for each folder (node) inside role root folder: 
	for NODE in [1-9]*; do
		echo "+++++++++++ NODE: $NODE +++++++++++"
		echo $CONSOLE_BR

		#############################
		# Define NODE vars 
		#############################
	   
	# VARS for NODE are stored in "Node" file include in each node folder for each role 
	getVars $NODE"/Node" "NODE_NAME"
	echo $CONSOLE_BR
   
	# test folder is patern validated:
		#if [[ "$NODE" =~ [â-zA-Zà-9\ ] ]]; then
		# yes folder name follows patern
		DEFAULT="N"
			echo $CONSOLE_HL
		read -e -p ":::: Proceed $NODE installation ? [N/y/q]:" PROCEED
		PROCEED="${PROCEED:-${DEFAULT}}"
		if [ "${PROCEED}" == "y" ] ; then
				echo ">>>> Node $NODE: Installing"
				echo $CONSOLE_BR
		cd $NODE/
			ROOT_PATH="../$ROOT_PATH"
				echo "#### pwd: $(pwd)"
				echo "#### root_path: $ROOT_PATH"
				echo $CONSOLE_BR
				echo " - - ROSRUN_EXE=$ROSRUN_EXE"
				echo $CONSOLE_BR
				
			#############################
				# Run 1g_update to create simlinks and copy files to local for first time 
				#############################
				
				DEFAULT="y"
				echo $CONSOLE_HL
		read -e -p ":::: Run 1g_update program to update files in node directory ($NODE)  ? [N/y/q] ": PROCEED
				PROCEED="${PROCEED:-${DEFAULT}}"
				if [ "${PROCEED}" == "y" ] ; then 
				   echo ">>>> Run 1g_update.sh" 
				   echo $CONSOLE_BR 

		   source $ROOT_PATH""$GLOBAL_PATH"/1g_update.sh"

				   echo "#### 0_install.sh execution finished" 
				else
				   echo "#### 1g_update program running aborded !"
				fi
				echo $CONSOLE_BR 


			#############################
				# Run  
				#############################


			echo "#### Node $i: Installation done"
		else
			echo "#### Installation $i aborded !"
		fi
			echo $CONSOLE_BR 
		#fi
    done

else
        echo "#### invalid entry, please relaunch program after terminating"
        echo $CONSOLE_BR
fi

echo "#### installation aborded !"
echo $CONSOLE_BR
