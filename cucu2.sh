#!/bin/bash

#telegramm bot rada - SEND

ftb=/usr/share/zabbix/local/trbot/
cuf=/usr/share/zabbix/local/trbot/
fPID=/usr/share/zabbix/local/trbot/cu2_pid.txt

Z1="0"

if ! [ -f $fPID ]; then		#----------------------- старт------------------
PID=$$
echo $PID > $fPID
token=$(sed -n "1p" $ftb"settings.conf" | tr -d '\r')
chat_id=$(sed -n "9p" $cuf"settings.conf" | tr -d '\r')
#Z1=$(sed -n "1p" $cuf"send.txt" | tr -d '\r')
f_text=$(sed -n "2p" $cuf"send.txt" | tr -d '\r')
proxy=$(sed -n 12"p" $ftb"settings.conf" | tr -d '\r')
bicons=$(sed -n 13"p" $ftb"settings.conf" | tr -d '\r')

[ "$bicons" == "1" ] && Z1=$(sed -n "1p" $cuf"send.txt" | tr -d '\r')


IFS=$'\x10'
echo "Z1="$Z1
echo "f_text="$f_text
text=`cat $f_text`


echo "token="$token
echo "chat_id="$chat_id
echo $text

if [ -z "$proxy" ]; then
[ "$Z1" == "0" ] && curl -k -L -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$text > $cuf"out0.txt"
[ "$Z1" == "1" ] && curl -k -L -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>&#10060;</b>"$text > $cuf"out0.txt"
[ "$Z1" == "2" ] && curl -k -L -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>&#9989</b>"$text > $cuf"out0.txt"
else
[ "$Z1" == "0" ] && curl --proxy $proxy -k -L -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$text > $cuf"out0.txt"
[ "$Z1" == "1" ] && curl --proxy $proxy -k -L -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>&#10060;</b>"$text > $cuf"out0.txt"
[ "$Z1" == "2" ] && curl --proxy $proxy -k -L -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>&#9989</b>"$text > $cuf"out0.txt"
fi


mv $cuf"out0.txt" $cuf"out.txt"

fi #----------------------- конец старт------------------
rm -f $fPID
