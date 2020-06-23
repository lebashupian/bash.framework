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


	echo -e "\033[33m $prompt \033[0m"  
	read  #""	
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
	echo -e "\e[44m $cmd \e[0m"
	echo $cmd
	output=`eval "$cmd" 2>&1`
	exe_code=$?
	[[ "$exe_code" == "0" ]] && {
		#echo -e "$output"
		#echo -e "\033[32m $1 ok \033[0m"
		echo -e "\033[32m $output \033[0m"
		return 0
	} || {
		#echo -e "$output"
		#echo -e "\033[31m check $1 failed \033[0m"
		echo -e "\033[31m $output \033[0m"
		return 1
	}
}

function today() {
	local deviation="+0"
	[[ ! -z $1 ]] && deviation="$1"
	date +%F@ -d "$deviation day"
}

function datetime() {
	local deviation="+0"
	[[ ! -z $1 ]] && deviation="$1"
	date +%F@%T -d "$deviation day"
}

function now() {
	local deviation="+0"
	[[ ! -z $1 ]] && deviation="$1"
	date +%T -d "$deviation hours"
}

