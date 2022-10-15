#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

fhome=/usr/share/zabbix/local/trbot/
fhomes=$fhome"s/"
fhomet=$fhome"t/"
fhomePD=$fhome"pd/"

sec4=$(sed -n 10"p" $fhome"settings.conf" | tr -d '\r')
sec4=$((sec4/1000))
name=$(sed -n 5"p" $ftb"settings.conf" | tr -d '\r')
sec=$(sed -n 6"p" $ftb"settings.conf" | tr -d '\r')
log=$(sed -n 2"p" $ftb"settings.conf" | tr -d '\r')


function logger()	
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" trbot_sender-"$name": "$1 >> $log
}



send ()
{
#logger "send start"
bic=$(sed -n "1p" $fhome"send.txt" | tr -d '\r')
otv=$(sed -n "2p" $fhome"send.txt" | tr -d '\r')
logger "send bic="$bic" otv="$otv
dl=$(wc -m $otv | awk '{ print $1 }')
logger "send dl="$dl
if [ "$dl" -gt "3950" ]; then
	sv=$(echo "$dl/3950" | bc)
	sv=$((sv+1))
	logger "send sv="$sv
	$fhome"rex.sh" $otv
	
	for (( i=1;i<=$sv;i++)); do
		fotv=$fhome"rez"$i".txt"
		f_send=$fhome"send.txt"
		echo $bic > $f_send
		echo $fotv >> $f_send
		send1
		#rm -f $fhome"rez"$i".txt"
	done
else
	send1;
fi
}

send1 () 
{
#logger "send1 start"
rm -f $fhome"out.txt"
$fhome"cucu2.sh" &
pauseloop;

if [ -f $fhome"out.txt" ]; then
	if [ "$(cat $fhome"out.txt" | grep ":true,")" ]; then	
		logger "send1 OK"
	else
		logger "send1 file+, timeout.."
		cat $fhome"out.txt" >> $log
		ider_sender;
		echo " " >> $fhome"fail_log.txt"
		echo $(cat $otv) >> $fhome"fail_log.txt"
		echo $(cat $fhome"out.txt") >> $fhome"fail_log.txt"
		sleep $sec4
	fi
else	
	logger "send1 FAIL"
	if [ -f $fhome"cu2_pid.txt" ]; then
		logger "send1 kill cucu2"
		cu_pid=$(sed -n 1"p" $fhome"cu2_pid.txt" | tr -d '\r')
		killall cucu2.sh
		kill -9 $cu_pid
		rm -f $fhome"cu2_pid.txt"
		
		ider_sender;
		cp -f $otv $fhomet"send"$ider_sender1".txt"
		fotv=$fhomet$ider_sender1".txt"
		echo $bic > $fhomePD"send"$ider_sender1".txt"
		echo $fotv >> $fhomePD"send"$ider_sender1".txt"
		sleep $sec4
	fi
fi

rm -f $fhome"send.txt"
#logger "send1 exit"
}


ider_sender ()
{
ider_sender1=$(sed -n 1"p" $fhome"send_id.txt" | tr -d '\r')
ider_sender1=$((ider_sender1+1))
echo $ider_sender1 > $fhome"send_id.txt"
}


pauseloop ()  		
{
sec1=0
again0="yes"
while [ "$again0" = "yes" ]
do
sec1=$((sec1+1))
sleep 1
if [ -f $fhome"out.txt" ] || [ "$sec1" -eq "$sec" ]; then
	again0="go"
	logger "pauseloop sec1="$sec1
fi
done
}



PID=$$
echo $PID > $fhome"sender_pid.txt"
while true
do
sleep $sec4
cd $fhomes
sf=$(ls | sed -n '/.txt/p' | sed '/^$/d' | sed -n '1p')
if ! [ -z "$sf" ]; then
	logger "sfile="$sf
	echo $(sed -n "1p" $fhomes$sf | tr -d '\r') > $fhome"send.txt"
	echo $(sed -n "2p" $fhomes$sf | tr -d '\r') >> $fhome"send.txt"
	send;
	rm -f $fhomes$sf
	rm -f $fhomet$sf
fi
done


