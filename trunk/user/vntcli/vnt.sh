#!/bin/sh

/usr/bin/vnt-cli --stop
#关闭vnt的防火墙
iptables -D INPUT -i hxsdwan -j ACCEPT 2>/dev/null
iptables -D FORWARD -i hxsdwan -o hxsdwan -j ACCEPT 2>/dev/null
iptables -D FORWARD -i hxsdwan -j ACCEPT 2>/dev/null
iptables -t nat -D POSTROUTING -o hxsdwan -j MASQUERADE 2>/dev/null
killall vnt-cli
killall -9 vnt-cli
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

/usr/bin/vnt-cli -k $vntcli_token $vntcli_serverw -d $vntcli_desname --nic hxsdwan -i $vntcli_localadd -o $lan_ipaddr/24 --ip $vntcli_ip &

sleep 4
if [ ! -z "`pidof vnt-cli`" ] ; then
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
