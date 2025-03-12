#!/bin/sh

/usr/bin/vpn --stop
#关闭vnt的防火墙
iptables -D INPUT -i hxsdwan -j ACCEPT 2>/dev/null
iptables -D FORWARD -i hxsdwan -o hxsdwan -j ACCEPT 2>/dev/null
iptables -D FORWARD -i hxsdwan -j ACCEPT 2>/dev/null
iptables -t nat -D POSTROUTING -o hxsdwan -j MASQUERADE 2>/dev/null
killall vpn
killall -9 vpn
sleep 4
#清除vnt的虚拟网卡
ifconfig hxsdwan down && ip tuntap del hxsdwan mode tun
#启动命令 更多命令去官方查看

vntcli_token=$(nvram get vntcli_token)
echo $vntcli_token
vntcli_desname=$(nvram get vntcli_desname)
echo $vntcli_desname
vntcli_ip=$(nvram get vntcli_ip)
echo $vntcli_ip
vntcli_localadd=$(nvram get vntcli_localadd)
echo $vntcli_localadd
vntcli_serverw=$(nvram get vntcli_serverw)
echo $vntcli_serverw

lan_ipaddr=$(nvram get lan_ipaddr) 
echo $lan_ipaddr

/usr/bin/vpn -k $vntcli_token $vntcli_serverw -d $vntcli_desname --nic hxsdwan -i $vntcli_localadd -o $lan_ipaddr/24 --ip $vntcli_ip &

sleep 4
if [ ! -z "`pidof vpn`" ] ; then
logger -t "异地组网" "启动成功"
#放行vpn防火墙
iptables -I INPUT -i hxsdwan -j ACCEPT
iptables -I FORWARD -i hxsdwan -o hxsdwan -j ACCEPT
iptables -I FORWARD -i hxsdwan -j ACCEPT
iptables -t nat -I POSTROUTING -o hxsdwan -j MASQUERADE
#开启arp
ifconfig hxsdwan arp
else
logger -t "异地组网" "启动失败"
fi
}

vnt_error="错误：${VNTCLI} 未运行，请运行成功后执行此操作！"
vnt_process=$(pidof vnt-cli)
vntpath=$(dirname "$VNTCLI")
cmdfile="/tmp/vnt-cli_cmd.log"

vnt_info() {
	if [ ! -z "$vnt_process" ] ; then
		cd $vntpath
		./vnt-cli --info >$cmdfile 2>&1
	else
		echo "$vnt_error" >$cmdfile 2>&1
	fi
	exit 1
}

vnt_all() {
	if [ ! -z "$vnt_process" ] ; then
		cd $vntpath
		./vnt-cli --all >$cmdfile 2>&1
	else
		echo "$vnt_error" >$cmdfile 2>&1
	fi
	exit 1
}

vnt_list() {
	if [ ! -z "$vnt_process" ] ; then
		cd $vntpath
		./vnt-cli --list >$cmdfile 2>&1
	else
		echo "$vnt_error" >$cmdfile 2>&1
	fi
	exit 1
}

vnt_route() {
	if [ ! -z "$vnt_process" ] ; then
		cd $vntpath
		./vnt-cli --route >$cmdfile 2>&1
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
