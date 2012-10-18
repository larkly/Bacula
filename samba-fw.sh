#! /bin/bash

IPT=/sib/iptables
LOCAL_NET='172.16.0.0/24'
LOCAL_HOST='127.0.0.1'
IFACE0='eth0'
IFACE1='eth1'
HTTP='80'
HTTPS='443'
DNS='53'
SSH='45734'
NETBIOS_SSN='139'
NETBIOS_NS='137'
NETBIOS_DGM='138'
MS_DS='445'
NTP='123'
WINBIND='49155'

# Clearing all chains

$IPT -F INPUT
$IPT -F FORWARD
$IPT -F OUTPUT

# Setting up DROP policy to all chains by default

$IPT -P INPUT DROP
$IPT -P FORWARD DROP
$IPT -P OUTPUT DROP

# INPUT chain rules

$IPT -A INPUT -i lo -j ACCEPT 
$IPT -A INPUT -s $LOCAL_HOST -j ACCEPT
$IPT -A INPUT -d $LOCAL_HOST -j ACCEPT
$IPT -A INPUT -p tcp -m tcp -d $LOCAL_NET --sport $HTTP -j ACCEPT
$IPT -A INPUT -p tcp -m tcp -d $LOCAL_NET --sport $HTTPS -j ACCEPT
$IPT -A INPUT -p tcp -m tcp -d $LOCAL_NET --sport $DNS -j ACCEPT
$IPT -A INPUT -p udp -m udp -d $LOCAL_NET --sport $DNS -j ACCEPT
$IPT -A INPUT -p tcp -m tcp -d $LOCAL_NET --sport $SSH -j ACCEPT
$IPT -A INPUT -p tcp -m tcp -s $LOCAL_NET -d $LOCAL_NET --sport $NETBIOS_SSN -j ACCEPT
$IPT -A INPUT -p udp -m udp -s $LOCAL_NET -d $LOCAL_NET --sport $NETBIOS_NS -j ACCEPT
$IPT -A INPUT -p udp -m udp -s $LOCAL_NET -d $LOCAL_NET --sport $NETBIOS_DGM -j ACCEPT
$IPT -A INPUT -p tcp -m tcp -s $LOCAL_NET -d $LOCAL_NET --sport $MS_DS -j ACCEPT
$IPT -A INPUT -p tcp -m tcp -s $LOCAL_NET -d $LOCAL_NET --sport $WINBIND -j ACCEPT
$IPT -A INPUT -p udp -m udp -s $LOCAL_NET -d $LOCAL_NET --sport $NTP -j ACCEPT
$IPT -A INOUT -p icmp -s $LOCAL_NET -d $LOCAL_NET -j ACCEPT

# OUTPUT chain rules

$IPT -A OUTPUT -o lo -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_HOST -j ACCEPT
$IPT -A OUTPUT -d $LOCAL_HOST -j ACCEPT
$IPT -A OUTPUT -p tcp -m tcp -s $LOCAL_NET --dport $HTTP -j ACCEPT
$IPT -A OUTPUT -p tcp -m tcp -s $LOCAL_NET --dport $HTTPS -j ACCEPT
$IPT -A OUTPUT -p tcp -m tcp -s $LOCAL_NET --dport $DNS -j ACCEPT
$IPT -A OUTPUT -p udp -m udp -s $LOCAL_NET --dport $DNS -j ACCEPT
$IPT -A OUTPUT -p tcp -m tcp -s $LOCAL_NET --dport $SSH -j ACCEPT
$IPT -A OUTPUT -p tcp -m tcp -s $LOCAL_NET -d $LOCAL_NET --dport $NETBIOS_SSN -j ACCEPT
$IPT -A OUTPUT -p udp -m udp -s $LOCAL_NET -d $LOCAL_NET --dport $NETBIOS_NS -j ACCEPT
$IPT -A OUTPUT -p udp -m udp -s $LOCAL_NET -d $LOCAL_NET --dport $NETBIOS_DGM -j ACCEPT
$IPT -A OUTPUT -p tcp -m tcp -s $LOCAL_NET -d $LOCAL_NET --dport $MS_DS -j ACCEPT
$IPT -A OUTPUT -p tcp -m tcp -s $LOCAL_NET -d $LOCAL_NET --dport $WINBIND -j ACCEPT
$IPT -A OUTPUT -p udp -m udp -s $LOCAL_NET -d $LOCAL_NET --dport $NTP -j ACCEPT
$IPT -A OUTPUT -p icmp -s $LOCAL_NET -d $LOCAL_NET -j ACCEPT

$ Log all dropped packets

$IPT -A INPUT -j LOG --log-prefix "INPUT DROP: "
$IPT -A OUTPUT -j LOG --log-prefix "OUTPUT DROP: "
