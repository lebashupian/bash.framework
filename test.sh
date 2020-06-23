#!/bin/bash
source ./base_function.sh

function test() {
	#单元测试

	#
	echo_color "error" "test msg ..."
	echo_color "warn" "test msg ..."
	echo_color "info" "test msg ..."
	echo_color "abc" "test msg ..."
	#
	pause
	pause "中断"

	#
	run_cmd date

	run_cmd date2 || pause

	log_to  /tmp/run.log "fsfsfs"

	today "+2"
	today
	today "-1"

	datetime

	now "+1"
	exit_msg "fsfsf" 1
}
test
