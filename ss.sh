#!/bin/bash

home_trbot=/usr/share/zabbix/local/trbot/
s="Server OFF"
[ "$(systemctl status zabbix-server | grep Active | grep -c running)" == "1" ] && s="Server ON"
echo $s > $home_trbot"ss.txt"



