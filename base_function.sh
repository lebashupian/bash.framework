#!/bin/bash
#
# v=0.0.1
#

function echo_color() {
	case "$1" in
		"error")
			#echo -e "\033[31m红色字\033[0m"
			echo -e "\033[31m [error] $2 \033[0m"    	
		;;
		"warn")
			#echo -e "\033[33m黄色字\033[0m"  
			echo -e "\033[33m [warn] $2 \033[0m"  
		;;
		"info")
			#echo -e "\033[32m绿色字\033[0m"
			echo -e "\033[32m [info] $2 \033[0m"    
		;;
		*)
			#echo -e "\033[44;30m蓝底黑字\033[0m"  
			echo -e "\033[44;30m [msg_type_undefing] $2\033[0m"   
		;;
	esac
}

function exit_msg() {
	local msg=''
	local exit_code=1
	[[ ! -z $1 ]] && msg=$1
	[[ ! -z $2 ]] && exit_code=$2
	echo $msg
	exit $exit_code
}


function pause() {
	[[ $1 == '' ]] && {
		prompt='pause , you can type any key to continue'
	} || {
		prompt=$1
	}

	#echo -ne "\033[33m$prompt\033[0m"
	read -p "`echo -ne "\033[33m$prompt\033[0m"`"
}




function alert_to_dingding() {
	#
	# 待定义接口
	#
	url=''
	receiver=''
	msg=''
	[[ -z $1 ]] && msg=$1
	curl $url
}

function log_to() {
	local log_file=/dev/null
	local log_msg=''
	[[ ! -z "$1" ]] && log_file=$1
	[[ ! -z "$2" ]] && log_msg=$2
	echo "$log_msg" >> $log_file
}


function run_cmd() {
	local cmd=''
	[[ ! -z "$1" ]] && cmd=$1
	#蓝色背景，加粗，白字
	echo -e "\e[1;44m$cmd\e[0m"
	output=`eval "$cmd" 2>&1`
	exe_code=$?
	[[ "$exe_code" == "0" ]] && {
		#echo -e "$output"
		#echo -e "\033[32m $1 ok \033[0m"
		echo -e "\033[1;32m$output\033[0m"
		[[ $debug_mode == "pause" ]] && pause
		return 0
	} || {
		#echo -e "$output"
		#echo -e "\033[31m check $1 failed \033[0m"
		echo -e "\033[1;31m$output\033[0m"
		[[ $debug_mode == "pause" ]] && pause
		return 1
	}
}

function day() {
	local deviation="+0"
	[[ ! -z $1 ]] && deviation="$1"
	date +%F -d "$deviation day"
}

function datetime() {
	local deviation="+0"
	[[ ! -z $1 ]] && deviation="$1"
	date +%F@%T -d "$deviation min"
}

function now() {
	local deviation="+0"
	[[ ! -z $1 ]] && deviation="$1"
	date +%T -d "$deviation min"
}


function return_script_dir() {
	basedir=`cd $(dirname $0); pwd -P`
	echo $basedir	
}



function winbox() {
	[[ $1 == input ]] && {
		local inputbox=''
		inputbox=$(whiptail --title "Dialog " --inputbox "$2"  10 50  3>&1 1>&2 2>&3);
		echo "$inputbox"
		#return 0
	}

	[[ $1 == button ]] && {
		if (whiptail --title "Dialog" --yes-button "Y" --no-button "N" --yesno "$2" 10 50) then
			return 0
		else
			return 1
		fi;
	}

	[[ $1 == redio ]] && {
		shift 1
		DISTROS=$(whiptail --title "Dialog" --radiolist \
		"redio" 15 60 4 \
		$@  3>&1 1>&2 2>&3)
		echo $DISTROS
	}

	[[ $1 == check ]] && {
		shift 1
		DISTROS=$(whiptail --title "Dialog" --checklist \
		"checklist" 15 60 4 \
		$@ 3>&1 1>&2 2>&3)
		echo $DISTROS	
	}

	[[ $1 == password ]] && {
		local PASSWORD=''
		PASSWORD=$(whiptail --title "Password Box" --passwordbox "Enter your password and choose Ok to continue." 10 60 3>&1 1>&2 2>&3)
		echo $PASSWORD
		#exitstatus=$?
		#if [ $exitstatus = 0 ]; then
		#    echo "Your password is:" $PASSWORD
		#else
		#    echo "You chose Cancel."
		#fi		
	}

	[[ $1 == menu ]] && {
		shift 1
		OPTION=$(whiptail --title "Dialog" --menu "menu" 15 60 4 \
		$@  3>&1 1>&2 2>&3)
		echo $OPTION
	}

	[[ $1 == process ]] && {
		whiptail --gauge "Please wait while installing" 6 60 0
	}
}

#
function a_whether_include_b() {
	#echo $2
	for i in $2
	do
		i=`echo $i|sed 's/"//g'`
		#echo "$1----$i"
		[[ $1 == $i ]] && {
			return 0
		}
	done
	return 1
}