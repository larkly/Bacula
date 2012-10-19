#! /bin/bash

IPT=/sbin/iptables
LOCAL_HOST='127.0.0.1'
LOCAL_NET='192.168.1.0/24'
HTTP='80'
HTTPS='443'
DNS='53'
SMTP='25'
SSH='45734'
RPC='135'
NTB_NS='137'
NTB_DGM='138'
NTB_SSN='139'
KRB='88'
KRB_ADM='749'
KRB_IV='750'
LDAP='389'
MS_DS='445'
NTP='123'
WINBIND='49155,49156'
UPS1='3052'
UPS2='53568'

# Clearing all chains

$IPT -F INPUT
$IPT -F FORWARD
$IPT -F OUTPUT

# Setting up DROP policy by default

$IPT -P INPUT DROP
$IPT -P FORWARD DROP
$IPT -P OUTPUT DROP

# INPUT chain rules

## Localhost input rules

$IPT -A INPUT -i lo -j ACCEPT 
$IPT -A INPUT -s $LOCAL_HOST -j ACCEPT 
$IPT -A INPUT -d $LOCAL_HOST -j ACCEPT 

## NetBIOS / RPC / Winbind input rules

$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --sport $NTB_DGM -j ACCEPT 
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --dport $NTB_SSN -j ACCEPT 
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --sport $NTB_NS -j ACCEPT
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --dport $MS_DS -j ACCEPT 
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --sport $MS_DS -j ACCEPT
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --sport $RPC -j ACCEPT
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m -multiports $WINBIND -j ACCEPT 

## Kerberos input rules

$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --sport $KRB -j ACCEPT 
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --sport $KRB -j ACCEPT 
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --sport $KRB_IV -j ACCEPT 
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --sport $KRB_ADM -j ACCEPT 
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --sport $KRB_ADM -j ACCEPT

## LDAP input rules

$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --sport $LDAP -j ACCEPT 
$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --sport $LDAP -j ACCEPT

## HTTP / HTTPS input rules

$IPT -A INPUT -d $LOCAL_NET -p tcp -m tcp --sport $HTTP -j ACCEPT 
$IPT -A INPUT -d $LOCAL_NET -p tcp -m tcp --sport $HTTPS -j ACCEPT 

## DNS input rules

$IPT -A INPUT -d $LOCAL_NET -p tcp -m tcp --sport $DNS -j ACCEPT 
$IPT -A INPUT -d $LOCAL_NET -p udp -m udp --sport $DNS -j ACCEPT 

## SSH input rules

$IPT -A INPUT -d $LOCAL_NET -p tcp -m tcp --dport $SSH -j ACCEPT 

## UPS daemon input rules

$IPT -A INPUT -d $LOCAL_NET -p tcp -m tcp --dport $UPS1 -j ACCEPT
$IPT -A INPUT -d $LOCAL_NET -p tcp -m tcp --dport $UPS2 -j ACCEPT 

## NTP input rules

$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --sport $NTP -j ACCEPT 

## ICMP input rules

$IPT -A INPUT -s $LOCAL_NET -d $LOCAL_NET -p icmp -j ACCEPT 

# OUTPUT chain rules

## Localhost input rules

$IPT -A OUTPUT -o lo -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_HOST -j ACCEPT 
$IPT -A OUTPUT -d $LOCAL_HOST -j ACCEPT 

## NetBIOS / RPC / Winbind output rules

$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --dport $NTB_DGM -j ACCEPT
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --sport $NTB_SSN -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --dport $NTB_NS -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --dport $MS_DS -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --sport $MS_DS -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --dport $RPC -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --dport $WINBIND -j ACCEPT

## Kerberos output rules

$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --dport $KRB -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --dport $KRB -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --dport $KRB_IV -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --dport $KRB_ADM -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --dport $KRB_ADM -j ACCEPT

## LDAP output rules

$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p tcp -m tcp --dport $LDAP -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --dport $LDAP -j ACCEPT 

## HTTP / HTTPS output rules

$IPT -A OUTPUT -s $LOCAL_NET -p tcp -m tcp --dport $HTTP -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -p tcp -m tcp --dport $HTTPS -j ACCEPT 

## DNS output rules

$IPT -A OUTPUT -s $LOCAL_NET -p tcp -m tcp --dport $DNS -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -p udp -m udp --dport $DNS -j ACCEPT 

## SSH output rules
$IPT -A OUTPUT -s $LOCAL_NET -p tcp -m tcp --sport $SSH -j ACCEPT 

## UPS daemon output rules

$IPT -A OUTPUT -s $LOCAL_NET -p tcp -m tcp --sport $UPS1 -j ACCEPT 
$IPT -A OUTPUT -s $LOCAL_NET -p tcp -m tcp --sport $UPS2 -j ACCEPT 

## NTP output rules

$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p udp -m udp --dport $NTP -j ACCEPT 

## ICMP output rules

$IPT -A OUTPUT -s $LOCAL_NET -d $LOCAL_NET -p icmp -j ACCEPT 

# Log all dropped packets

$IPT -A OUTPUT -j LOG --log-prefix "OUTPUT DROP: " 
$IPT -A INPUT -j LOG --log-prefix "INPUT DROP: " 
