#!/bin/bash
#set -x

red="\033[31m"
green="\033[32m"
yellow="\033[33m"
white="\033[0m"

start() {
	clear
	rm -rf /tmp/ping.txt

	echo -e "$green>>请稍等开始并发ping IP$white"
	
	for Host in `seq 1 254`;do
	{
		ping -c 1 $Network.$Host >/dev/null && result=0 || result=1
		if [ "$result" == "0" ];then
			echo "IP:$Network.$Host ok" >>/tmp/ping.txt
		else
			echo "IP:$Network.$Host eeror" >>/tmp/ping.txt
		fi
	}&
	done
	wait

	echo -e "$green>>并发结束$white" && sleep 1
	
	sort -t "." -k 4 -n  /tmp/ping.txt -o /tmp/ping.txt

	for catip in `seq 1 254`
	do
		ping_num=$(sed -n "${catip}p" /tmp/ping.txt)
		if [[ `echo $ping_num | grep -o "ok"` == "ok" ]];then
			echo -e "$green${ping_num}$white"
		else
			echo -e "$red${ping_num}$white"
		fi
		#sleep 1
	done
}

if [[ -z $1 ]]; then
	echo "请输入IP地址，如 bash ping.sh 192.168.1"
else
	Network=$1
	start
fi
