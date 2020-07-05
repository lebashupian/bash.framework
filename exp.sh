#!/bin/bash
source ./base_function.sh
debug_mode='pause'

run_cmd "ls" 
run_cmd "date" 
run_cmd "date3" 
var='sshd'
run_cmd "netstat -ntpl|grep $var"


run_cmd "
ps -ef|grep root|grep sshd|while read line
do
echo \$line
done
"

wxl=$(winbox input 提示)
echo $wxl
if (winbox button "按键") then
echo Y
else
echo N
fi


winbox button abc  && {
echo Y
} || {
echo N
}

opt=$(winbox redio wxl sss off wxl2 ssss on)
echo $opt
opt=$(winbox menu m1 "m1..." m2 "m2....")
echo $opt

opts=$(winbox check opt1 sss off opt2 ssss on)
#echo $opts

#exit

log_to "/tmp/1.log" "test"


a_whether_include_b opt1 "$opts" && echo in || echo not in
a_whether_include_b opt2 "$opts" && echo in || echo not in


password=$(winbox password)
echo $password

{
echo 10
sleep 0.5
echo 20
sleep 0.5
echo 100
sleep 0.5
} | winbox process



dir=$(return_script_dir)
echo "获取的脚本目录是$dir"


day -2
day +3
datetime
datetime +10
datetime -10
now +10
now
now -10


zbx_server='192.168.137.1'
zbx_sender='/opt/zabbix/bin/zabbix_sender'
zbx_receiver='msg-receiver'
zbx_key='alert-txt'
zbx_port='10051'	


send_msg_to_zbx "hello"