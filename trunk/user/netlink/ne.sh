#!/bin/sh


#关闭nehxkj的防火墙
iptables -D INPUT -i nehxkj -j ACCEPT 2>/dev/null
iptables -D FORWARD -i nehxkj -o nehxkj -j ACCEPT 2>/dev/null
iptables -D FORWARD -i nehxkj -j ACCEPT 2>/dev/null
iptables -t nat -D POSTROUTING -o nehxkj -j MASQUERADE 2>/dev/null
killall netlink
killall -9 netlink
sleep 5
#清除vnt的虚拟网卡
ifconfig nehxkj down && ip tuntap del nehxkj mode tun

/etc/storage/netlink --tun-name nehxkj  -g ok2233768 -l 10.26.2.10/24 -p tcp://107.172.30.239:23333 &

sleep 5

route add -net 192.168.20.0/24 gw 10.26.2.20

if [ ! -z "`pidof netlink`" ] ; then
logger -t "netlink" "启动成功"
#放行netlink防火墙
iptables -I INPUT -i nehxkj -j ACCEPT
iptables -I FORWARD -i nehxkj -o nehxkj -j ACCEPT
iptables -I FORWARD -i nehxkj -j ACCEPT
iptables -t nat -I POSTROUTING -o nehxkj -j MASQUERADE

#开启arp
ifconfig nehxkj arp
else
logger -t "netlink" "启动失败"
fi

