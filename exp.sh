#!/bin/bash
source ./base_function.sh

run_cmd "ls"
run_cmd "date"
run_cmd "date3"
run_cmd ifconfig
netcard='abc'
run_cmd "ifconfig|grep $netcard"