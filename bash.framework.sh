#!/bin/bash


function echo_color() {
	case "$1" in
		"error")
			#echo -e "\033[31m红色字\033[0m"
			echo -e "\033[1;31m [error] $2 \033[0m"    	
		;;
		"warn")
			#echo -e "\033[33m黄色字\033[0m"  
			echo -e "\033[1;33m [warn] $2 \033[0m"  
		;;
		"info")
			#echo -e "\033[32m绿色字\033[0m"
			echo -e "\033[1;32m [info] $2 \033[0m"    
		;;
		*)
			#echo -e "\033[44;30m蓝底黑字\033[0m"  
			echo -e "\033[44;30m [msg_type_undefing] $2\033[0m"   
		;;
	esac
}

function echo_debug() {
	#
	[[ $debug_mode == "pause" ]] && echo_color warn "debug ...."
}

function exit_msg() {
	local msg=''
	local exit_code=1
	[[ ! -z $1 ]] && msg=$1
	[[ ! -z $2 ]] && exit_code=$2
	echo_color error $msg
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


function send_msg_to_zbx() {
	value="$1"

	[[ -z $zbx_sender ]] && {
		echo_color warn "zbx_host主机变量没有被定义,使用预设变量"
		zbx_sender='/opt/zabbix/bin/zabbix_sender'
	}

	[[ -z $zbx_receiver ]] && {
		echo_color warn "zbx-receiver主机变量没有被定义,使用预设变量"
		zbx_receiver='msg-receiver'		
	}

	[[ -z $zbx_server ]] && {
		exit_msg "zbx_server变量没有被定义"
	}

	[[ -z $zbx_key ]] && {
		echo_color warn "zbx_key主机变量没有被定义,使用预设变量"
		zbx_key='alert-txt'		
	}

	[[ -z $zbx_port ]] && {
		echo_color warn "zbx_port主机变量没有被定义,使用预设变量"
		zbx_port='10051'		
	}	

	$zbx_sender -vv -s $zbx_receiver  -z  $zbx_server -p $zbx_port -k $zbx_key  -o "from $(hostname): $value"
}



function echo_header() {
	var_tpye=$1
	var_title=$2
	var_fill=''
	var_fill_char='-'
	var_complete_title=''

    case "$var_tpye" in
    	"h1" )
			var_length='75'
    		;;
    	"h2" )
			var_length='55'
    		;;
    	"h3" )
			var_length='35'
    		;;
    	"h4" )
			var_length='5'
    		;;   	
    esac
    #echo $var_tpye
    #echo $var_length
	for i in $(seq 1 $var_length)
	do
		#echo $i
		var_fill=${var_fill}${var_fill_char}
	done

	var_complete_title=${var_fill}${var_title}
	echo -e "\033[47;30m ${var_complete_title} \033[0m"  
}

#echo_header "h1" "ssfsf"
#echo_header "h2" "ss"
#echo_header "h2" "ss2222"
#echo_header "h3" "ssfsf"
#echo_header "h4" "ssfsf"