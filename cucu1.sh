#!/bin/bash

#telegramm bot rada INPUT
ftb=/usr/share/zabbix/local/trbot/
cuf=/usr/share/zabbix/local/trbot/
fPID=/usr/share/zabbix/local/trbot/cu1_pid.txt

#Z1=$1

if ! [ -f $fPID ]; then	
PID=$$
echo $PID > $fPID
token=$(sed -n 1"p" $ftb"settings.conf" | tr -d '\r')
proxy=$(sed -n 12"p" $ftb"settings.conf" | tr -d '\r')

if [ -z "$proxy" ]; then
	curl -L https://api.telegram.org/bot$token/getUpdates > $cuf"in0.txt"
else
	curl --proxy $proxy -L https://api.telegram.org/bot$token/getUpdates > $cuf"in0.txt"
fi

mv $cuf"in0.txt" $cuf"in.txt"

fi
rm -f $fPID
