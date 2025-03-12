#!/bin/sh

vnt_error="错误：${VNTCLI} 未运行，请运行成功后执行此操作！"
vnt_process=$(pidof vnt-cli)
vntpath=$(dirname "$VNTCLI")
cmdfile="/tmp/vnt-cli_cmd.log"

vnt_info() {
	if [ ! -z "$vnt_process" ] ; then
		cd $vntpath
		/usr/bin/vnt-cli --info >$cmdfile 2>&1
	else
		echo "$vnt_error" >$cmdfile 2>&1
	fi
	exit 1
}

vnt_all() {
	if [ ! -z "$vnt_process" ] ; then
		cd $vntpath
		/usr/bin/vnt-cli --all >$cmdfile 2>&1
	else
		echo "$vnt_error" >$cmdfile 2>&1
	fi
	exit 1
}

vnt_list() {
	if [ ! -z "$vnt_process" ] ; then
		cd $vntpath
		/usr/bin/vnt-cli --list >$cmdfile 2>&1
	else
		echo "$vnt_error" >$cmdfile 2>&1
	fi
	exit 1
}

vnt_route() {
	if [ ! -z "$vnt_process" ] ; then
		cd $vntpath
		/usr/bin/vnt-cli --route >$cmdfile 2>&1
	else
		echo "$vnt_error" >$cmdfile 2>&1
	fi
	exit 1
}

vnt_status() {
	if [ ! -z "$vnt_process" ] ; then
		vntcpu="$(top -b -n1 | grep -E "$(pidof vnt-cli)" 2>/dev/null| grep -v grep | awk '{for (i=1;i<=NF;i++) {if ($i ~ /vnt-cli/) break; else cpu=i}} END {print $cpu}')"
		echo -e "\t\t vnt-cli 运行状态\n" >$cmdfile
		[ ! -z "$vntcpu" ] && echo "CPU占用 ${vntcpu}% " >>$cmdfile 2>&1
		vntram="$(cat /proc/$(pidof vnt-cli | awk '{print $NF}')/status|grep -w VmRSS|awk '{printf "%.2fMB\n", $2/1024}')"
		[ ! -z "$vntram" ] && echo "内存占用 ${vntram}" >>$cmdfile 2>&1
		vnttime=$(cat /tmp/vntcli_time) 
		if [ -n "$vnttime" ] ; then
			time=$(( `date +%s`-vnttime))
			day=$((time/86400))
			[ "$day" = "0" ] && day=''|| day=" $day天"
			time=`date -u -d @${time} +%H小时%M分%S秒`
		fi
		[ ! -z "$time" ] && echo "已运行 $time" >>$cmdfile 2>&1
		cmdtart=$(cat /tmp/vnt-cli.CMD)
		[ ! -z "$cmdtart" ] && echo "启动参数  $cmdtart" >>$cmdfile 2>&1
		
	else
		echo "$vnt_error" >$cmdfile
	fi
	exit 1
}

case $1 in
start)
	start_vntcli &
	;;
stop)
	stop_vnt
	;;
restart)
	stop_vnt
	start_vntcli &
	;;
update)
	update_vntcli &
	;;
vntinfo)
	vnt_info
	;;
vntall)
	vnt_all
	;;
vntlist)
	vnt_list
	;;
vntroute)
	vnt_route
	;;
vntstatus)
	vnt_status
	;;
*)
	echo "check"
	#exit 0
	;;
esac
