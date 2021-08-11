#!/bin/bash


fhome=/usr/share/zabbix/local/trbot/
ftb=$fhome
cuf=$fhome
fm=$fhome"mail.txt"
mass_mesid_file=$fhome"mmid.txt"
home_trbot=$fhome



function Init2() 
{
logger "text="
log=$(sed -n 2"p" $ftb"settings.conf" | tr -d '\r')
regim=$(sed -n 3"p" $ftb"settings.conf" | tr -d '\r')
fPID=$(sed -n 4"p" $ftb"settings.conf" | tr -d '\r')
f_send=$(sed -n 5"p" $ftb"settings.conf" | tr -d '\r')
sec=$(sed -n 6"p" $ftb"settings.conf" | tr -d '\r')
opov=$(sed -n 7"p" $ftb"settings.conf" | tr -d '\r')
chat_id1=$(sed -n 9"p" $ftb"settings.conf" | tr -d '\r')
chat_id2=$(sed -n 10"p" $ftb"settings.conf" | tr -d '\r')
progons=$(sed -n 11"p" $ftb"settings.conf" | tr -d '\r')

last_id=$(sed -n 1"p" $ftb"lastid.txt" | tr -d '\r')
}

Init2;
send1=0

function logger()	
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" trbot: "$1 >> $log
}


if ! [ -f $log ]; then
mkdir -p /var/log/trbot/
echo " " > $log
else
echo " " >> $log
fi




regstat()	
{
str_col=$(grep -cv "^T" $ftb"settings.conf")
echo "str_col="$str_col

rm -f $ftb"settings1.conf" && touch $ftb"settings1.conf"

for (( i=1;i<=$str_col;i++)); do
test=$(sed -n $i"p" $ftb"settings.conf")
if [ "$i" -eq "3" ]; then
echo $regim >> $ftb"settings1.conf"
else
echo $test >> $ftb"settings1.conf"
fi
done

[ "$regim" -eq "1" ] && echo "Alerting mode ON" > $ftb"regim.txt"
[ "$regim" -eq "0" ] && echo "Alerting mode OFF" > $ftb"regim.txt"
otv="/usr/share/zabbix/local/trbot/regim.txt"
send1=1; send;

#echo $regim > $ftb"amode.txt"

cp -f $ftb"settings1.conf" $ftb"settings.conf"
}


roborob ()  	
{
date1=`date '+ %d.%m.%Y %H:%M:%S'`
logger "text="$text
otv=""

if [ "$text" = "/start" ] || [ "$text" = "/?" ] || [ "$text" = "/help" ] || [ "$text" = "/h" ]; then
	otv="/usr/share/zabbix/local/trbot/help.txt"
	send1=1; send;
fi

if [ "$text" = "/j" ] || [ "$text" = "/job" ]; then
	$ftb"job.sh"
	otv="/usr/share/zabbix/local/trbot/job.txt"
	send1=1; send;
fi

if [ "$text" = "/ss" ] || [ "$text" = "/status" ]; then
	$ftb"ss.sh"
	otv="/usr/share/zabbix/local/trbot/ss.txt"
	send1=1; send;
fi

if [[ "$text" == */d* ]]; then
	$ftb"del.sh" $text
	otv="/usr/share/zabbix/local/trbot/del.txt"
	send1=1; send;
fi

if [ "$text" = "/on" ]; then
	regim=1;
	regstat;
fi

if [ "$text" = "/off" ]; then
	regim=0;
	regstat;
fi

logger "roborob otv="$otv
}


send1 () 
{

logger "send1 start"

echo $chat_id > $cuf"send.txt"
echo $otv >> $cuf"send.txt"

rm -f $cuf"out.txt"
file=$cuf"out.txt"; 
$ftb"cucu2.sh" &
pauseloop;

if [ -f $cuf"out.txt" ]; then
	if [ "$(cat $cuf"out.txt" | grep ":true,")" ]; then	
		logger "send OK"
	else
		logger "send file+, timeout.."
		cat $cuf"out.txt" >> $log
		sleep 2
	fi
else	
	logger "send FAIL"
	if [ -f $cuf"cu2_pid.txt" ]; then
		logger "send kill cucu2"
		cu_pid=$(sed -n 1"p" $cuf"cu2_pid.txt" | tr -d '\r')
		killall cucu2.sh
		kill -9 $cu_pid
		rm -f $cuf"cu2_pid.txt"
	fi
fi

logger "send1 exit"

}

send ()
{
logger "send start"
rm -f $cuf"send.txt"

if [ "$send1" -eq "2" ]; then
		chat_id2=$(sed -n 10"p" $ftb"settings.conf" | sed 's/z/-/g' | tr -d '\r')
		chat_id=$chat_id2

	else
		chat_id1=$(sed -n 9"p" $ftb"settings.conf" | sed 's/z/-/g' | tr -d '\r')
		chat_id=$chat_id1

fi
logger "chat_id="$chat_id

dl=$(wc -m $otv | awk '{ print $1 }')
echo "dl="$dl
if [ "$dl" -gt "4000" ]; then
	sv=$(echo "$dl/4000" | bc)
	echo "sv="$sv
	$ftb"rex.sh" $otv
	
	for (( i=1;i<=$sv;i++)); do
		otv="/usr/share/zabbix/local/trbot/rez"$i".txt"
		send1;
		rm -f "/usr/share/zabbix/local/trbot/rez"$i".txt"
	done
	
else
	send1;
fi



logger "send exit"
}

pauseloop ()  		
{
sec1=0
rm -f $file
again0="yes"
while [ "$again0" = "yes" ]
do
sec1=$((sec1+1))
sleep 1
if [ -f $file ] || [ "$sec1" -eq "$sec" ]; then
	again0="go"
	logger "pauseloop sec1="$sec1
fi
done
}

input ()  		
{
logger "input start"

rm -f $cuf"in.txt"
file=$cuf"in.txt";
$ftb"cucu1.sh" &
pauseloop;

if [ -f $cuf"in.txt" ]; then
	if [ "$(cat $cuf"in.txt" | grep ":true,")" ]; then		
		logger "input OK"
	else
		logger "input file+, timeout.." #error_code
		cat $cuf"in.txt" >> $log
		ffufuf1=1
		sleep 2
	fi
else														
	logger "input FAIL"
	if [ -f $cuf"cu1_pid.txt" ]; then
		logger "input kill cucu1"
		cu_pid=$(sed -n 1"p" $cuf"cu1_pid.txt" | tr -d '\r')
		killall cucu1.sh
		kill -9 $cu_pid
		rm -f $cuf"cu1_pid.txt"
		ffufuf1=1
	fi
fi

logger "input exit"
}


lastidrass ()  				
{
if [ "$last_id" -le "$mi" ]; then
	last_id=$((mi+1))
	echo $last_id > $ftb"lastid.txt"
	logger "new last_id="$last_id
fi

}


parce ()					
{
logger "parce"
chat_id1=$(sed -n 9"p" $ftb"settings.conf" | tr -d '\r')

date1=`date '+ %d.%m.%Y %H:%M:%S'`
mi_col=$(cat $cuf"in.txt" | grep -c update_id | tr -d '\r')
logger "parce col mi_col ="$mi_col

if [ "$mi_col" -eq "0" ] && [ "$ffufuf1" -eq "0" ]; then
	echo "" > $mass_mesid_file
fi


for (( i=1;i<=$mi_col;i++)); do
	i1=$((i-1))
	mi=$(cat $cuf"in.txt" | jq ".result[$i1].update_id" | tr -d '\r')
	logger "update_id="$mi
	
	ffufuf=0
	for x in `cat $mass_mesid_file|grep -v \#|tr -d '\r'`
	do
		if [ "$x" -eq "$mi" ]; then
			ffufuf=1
			#logger "processed"
		fi
	done
	
	
	if [ "$ffufuf" -eq "0" ]; then
		chat_id=$(cat $cuf"in.txt" | jq ".result[$i1].message.chat.id" | sed 's/-/z/g' | tr -d '\r')
		logger "chat_id="$chat_id
		logger "chat_id1="$chat_id1
		if [ "$(echo $chat_id1 | grep $chat_id)" ]; then
			logger "parse chat_id="$chat_id" -> OK"
			#chat_id=$chat_id
			text=$(cat $cuf"in.txt" | jq ".result[$i1].message.text" | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
			logger $text
			echo $text > $home_trbot"t.txt"
			roborob;
			
			logger "parce ok"
			echo $mi >> $mass_mesid_file
		else
			logger "parce dont! chat_id="$chat_id" NOT OK"
		fi
	fi
	
done

lastidrass;
}

function to_send() 
{
logger "start to_send"

if ! [ -f $f_send ]; then							
	#chat_id1=$(sed -n 9"p" $ftb"settings.conf" | tr -d '\r')
	sleep 0
else 
	if [ "$regim" -eq "1" ]; then
		logger "regim ON"													
		#chat_id2=$(sed -n 10"p" $ftb"settings.conf" | sed 's/-/z/g' | tr -d '\r')
		otv=$f_send
		logger "chat alert chat_id="$chat_id2", otv="$otv
		send1=2; send;
		rm -f $f_send
	fi
fi

}


input2 ()  		
{
logger "input2 start"
str_col=$(grep -cv "^#" $fhome$lego"0.txt")
echo "str_col="$str_col
if [ "$str_col" -gt "0" ]; then
	cp -f $fhome$lego"0.txt" $fhome$lego"0_tmp.txt"
	rm -f $fhome$lego"0.txt"
	touch $fhome$lego"0.txt"

for (( i=1;i<=$str_col;i++)); do
	test=$(sed -n $i"p" $fhome$lego"0_tmp.txt" | tr -d '\r')
	echo $test > $f_send
	echo $test >> $fhome$lego".txt"
	to_send;
done

fi
}


if ! [ -f $fPID ]; then
PID=$$
echo $PID > $fPID
logger "start"
logger "chat_id1="$chat_id1
logger "chat_id2="$chat_id2
#echo $regim > $ftb"amode.txt"
otv="/usr/share/zabbix/local/trbot/start.txt"; send1=1; send;
kkik=0
touch $fhome"in_id0.txt"
touch $fhome"out_id0.txt"

while true
do
sec4=$(sed -n "8p" $ftb"settings.conf" | tr -d '\r')
sleep $sec4
ffufuf1=0

lego="in_id"; input2;
lego="out_id"; input2;
input;
parce;

kkik=$(($kkik+1))
[ "$kkik" -eq "$progons" ] && Init2

done


else 
	logger "pid up exit"

fi


rm -f $fPID




