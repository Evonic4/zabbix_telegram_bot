#!/bin/bash


fhome=/usr/share/zabbix/local/trbot/
fhomes=$fhome"s/"	#здесь файлы для оповещения
fhomet=$fhome"t/" 	#здесь файлы с текстом оповещения
fhomePD=$fhome"pd/"	#здесь неотправленные файлы для оповещения
ftb=$fhome
cuf=$fhome
fm=$fhome"mail.txt"
mass_mesid_file=$fhome"mmid.txt"
home_trbot=$fhome
starten=1
log=$(sed -n 2"p" $ftb"settings.conf" | tr -d '\r')
logger "log="$log

function Init2() 
{
logger "Init"
regim=$(sed -n 3"p" $ftb"settings.conf" | tr -d '\r')
logger "regim="$regim
fPID=$(sed -n 4"p" $ftb"settings.conf" | tr -d '\r')
logger "fPID="$fPID
name=$(sed -n 5"p" $ftb"settings.conf" | tr -d '\r')
logger "name="$name
sec=$(sed -n 6"p" $ftb"settings.conf" | tr -d '\r')
logger "sec="$sec
datasource=$(sed -n 7"p" $ftb"settings.conf" | tr -d '\r')
logger "datasource="$datasource
chat_id1=$(sed -n 9"p" $ftb"settings.conf" | tr -d '\r')
logger "chat_id1="$chat_id1
progons=$(sed -n 11"p" $ftb"settings.conf" | tr -d '\r')
logger "progons="$progons
bic="0"
logger "bic="$bic
last_id=$(sed -n 1"p" $ftb"lastid.txt" | tr -d '\r')
logger "last_id="$last_id
start2=$(sed -n 15"p" $ftb"settings.conf" | tr -d '\r')
logger "start2="$start2

mdt_start=$(sed -n 16"p" $ftb"settings.conf" | sed 's/\://g' | tr -d '\r')
logger "mdt_start="$mdt_start
mdt_end=$(sed -n 17"p" $ftb"settings.conf" | sed 's/\://g' | tr -d '\r')
logger "mdt_end="$mdt_end
sm=$(sed -n 18"p" $ftb"settings.conf" | tr -d '\r')
logger "sm="$sm
#rabbitmq
rserv=$(sed -n 19"p" $ftb"settings.conf" | tr -d '\r')
logger "rserv="$rserv
queue_in=$(sed -n 20"p" $ftb"settings.conf" | tr -d '\r')
logger "queue_in="$queue_in
queue_out=$(sed -n 21"p" $ftb"settings.conf" | tr -d '\r')
logger "queue_out="$queue_out
vhost=$(sed -n 22"p" $ftb"settings.conf" | tr -d '\r')
logger "vhost="$vhost
r_usr=$(sed -n 23"p" $ftb"settings.conf" | tr -d '\r')
logger "r_usr="$r_usr
r_pass=$(sed -n 24"p" $ftb"settings.conf" | tr -d '\r')
logger "r_pass="$r_pass

dddeee=$fhome"delete_id.txt"
kkik=0
}


function logger()	
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" trbot-"$name": "$1 >> $log
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
otv=$ftb"regim.txt"
bic="0"; send;

#echo $regim > $ftb"amode.txt"

cp -f $ftb"settings1.conf" $ftb"settings.conf"
}


roborob ()  	
{
date1=`date '+ %d.%m.%Y %H:%M:%S'`
logger "text="$text
otv=""
bic="0"

if [ "$text" = "/start" ] || [ "$text" = "/?" ] || [ "$text" = "/help" ] || [ "$text" = "/h" ]; then
	otv=$fhome"help1.txt"
	send;
fi

if [ "$text" = "/j" ] || [ "$text" = "/job" ]; then
	$ftb"job.sh"
	otv=$fhome"job.txt"
	send;
fi

if [ "$text" = "/ss" ] || [ "$text" = "/status" ]; then
	$ftb"ss.sh"
	otv=$fhome"ss.txt"
	send;
fi

if [[ "$text" == */d* ]]; then
	$ftb"del.sh" $text
	otv=$fhome"del.txt"
	send;
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


pauseloop ()  		
{
sec1=0
again0="yes"

while [ "$again0" = "yes" ]
do
sec1=$((sec1+1))
sleep 1
if [ -f $fhome"in.txt" ] || [ "$sec1" -eq "$sec" ]; then
	again0="go"
	logger "pauseloop sec1="$sec1
fi
done
}


input ()  		
{
#logger "input start"
local inputok=1

$ftb"cucu1.sh" &
pauseloop;

if [ -f $cuf"in.txt" ]; then
	if [ "$(cat $cuf"in.txt" | grep ":true,")" ]; then		
		logger "input OK"
	else
		logger "input timeout.." #error_code
		#cat $cuf"in.txt" >> $log
		ffufuf1=1
		sleep 1
		inputok=0
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
		sleep 1
		inputok=0
	fi
fi

return $inputok
}


lastidrass ()  				
{
if [ "$last_id" -le "$mi" ]; then
	last_id=$((mi+1))
	echo $last_id > $ftb"lastid.txt"
	logger "new last_id="$last_id
fi

}

starten_furer ()  				
{

input;
if [ "$starten" -eq "1" ]; then
	logger "starten_furer"
	upd_id=$(cat $ftb"in.txt" | jq ".result[].update_id" | tail -1 | tr -d '\r')
	if ! [ -z "$upd_id" ]; then
		echo $upd_id > $ftb"lastid.txt"
		else
		echo "0" > $ftb"lastid.txt"
	fi
	logger "starten_furer upd_id="$upd_id
	starten=0
fi

}


parce ()
{
#logger "parce start"
mi_col=$(cat $cuf"in.txt" | grep -c update_id | tr -d '\r')
upd_id=$(sed -n 1"p" $ftb"lastid.txt" | tr -d '\r')
logger "parce col lastid ="$upd_id" mi_col ="$mi_col

for (( i=1;i<=$mi_col;i++)); do
	i1=$((i-1))
	mi=$(cat $ftb"in.txt" | jq ".result[$i1].update_id" | tr -d '\r')
	logger "parce update_id="$mi

	[ -z "$mi" ] && mi=0
	
	logger "parce cycle upd_id="$upd_id", i="$i", mi="$mi
	if [ "$upd_id" -ge "$mi" ] || [ "$mi" -eq "0" ] || [ "$mi" == "null" ]; then
		ffufuf=1
		else
		ffufuf=0
	fi
	logger "parce cycle ffufuf="$ffufuf
	
	
	if [ "$ffufuf" -eq "0" ]; then
		date4=`date '+%H%M%S_%d%m%Y'`
		cp -f $ftb"in.txt" $ftb"logs/"$date4".txt"
		chat_id=$(cat $ftb"in.txt" | jq ".result[$i1].message.chat.id" | sed 's/-/z/g' | tr -d '\r')
		logger "parce chat_id="$chat_id
		if [ "$(echo $chat_id1|sed 's/-/z/g'| tr -d '\r'| grep $chat_id)" ]; then
			logger "parse chat_id="$chat_id" -> OK"
			text=$(cat $ftb"in.txt" | jq ".result[$i1].message.text" | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
			logger "parse text="$text
			#echo $text > $home_trbot"t.txt"
			roborob;
			
			logger "parce ok"
		else
			logger "parce dont! chat_id="$chat_id" NOT OK"
		fi
	fi
done
[ "$ffufuf" -eq "0" ] && echo $mi > $ftb"lastid.txt"

}


function send() 
{
#logger "start send"

if [ "$regim" -eq "1" ]; then
	logger "send regim ON"
	
	ider_sender;
	
	cp -f $otv $fhomet"send"$ider_sender1".txt"
	f_send=$fhomet"send"$ider_sender1".txt"
	echo $bic > $fhomes"send"$ider_sender1".txt"
	echo $f_send >> $fhomes"send"$ider_sender1".txt"
else
	logger "send regim OFF"
fi
}


ider_sender ()
{
ider_sender1=$(sed -n 1"p" $fhome"send_id.txt" | tr -d '\r')
ider_sender1=$((ider_sender1+1))
echo $ider_sender1 > $fhome"send_id.txt"
}

staaaaat ()
{
#sec1=0
again1="yes"
while [ "$again1" = "yes" ]
do
#sec1=$((sec1+1))
st1=$(stat $fhome"in_id.txt" | grep Size | awk '{print $2}')
cp -f $fhome"in_id.txt" $fhome"in_id_tmp.txt"
sed -i "/$test_id/d" $fhome"in_id_tmp.txt"
st2=$(stat $fhome"in_id.txt" | grep Size | awk '{print $2}')

if [ "$st1" == "$st2" ]; then
	cp -f $fhome"in_id_tmp.txt" $fhome"in_id.txt"
	again1="go"
	logger "staaaaat"
fi

sleep 0.1
done

}


#Severity{EVENT.SEVERITY}
input2 ()  		
{

if [ "$datasource" == "1" ]; then	#rabbitmq
logger "input2 datasource="$datasource
local q=$queue_in
[ "$lego" == "out_id" ] && q=$queue_out

curl -s -k -u $r_usr:$r_pass -H 'content-type:application/json' -X POST $rserv/api/queues/$vhost/$q/get -d '{"count":10,"ackmode":"ack_requeue_false","encoding":"auto","truncate":50000}' | jq '.[].payload' | sed 's/\"//g' > $fhome$lego"0.txt"

fi


str_col=$(grep -cv "^#" $fhome$lego"0.txt")

if [ "$str_col" -gt "0" ]; then
	logger "input2 "$lego" str_col="$str_col
	
for (( i=1;i<=$str_col;i++)); do #.*[]^${}\+?|()
	test=$(sed -n $i"p" $fhome$lego"0.txt" | sed 's/Information:/<b>\&\#9898\;<\/b>/g' | sed 's/Warning:/<b>\&\#x1F7E1\;<\/b>/g' | sed 's/Average:/<b>\&\#x1F7E0\;<\/b>/g' | sed 's/High:/<b>\&\#128308\;<\/b>/g' | sed 's/Disaster:/<b>\&\#128996\;<\/b>/g' | tr -d '\r')
	ider_sender;
	otv=$fhome"input2send.txt"
	echo $test > $otv
	[ "$lego" == "in_id" ] && echo $test >> $fhome"in_id.txt"
	test_id=$(echo $test | awk '{print $3}')
	logger "input2 out_id thinner test_id="$test_id
	dddeee=$fhome"delete_id.txt"
	if ! [ "$(grep $test_id $dddeee)" ]; then
		silent_mode;
		if [ "$silent_mode" == "on" ]; then
		[ "$(echo $test | grep "&\#128996;")" ] && send;
		[ "$(echo $test | grep "&\#128308;")" ] && send;
		else
		send;
		fi
	fi
	#thinner
	if [ "$lego" == "out_id" ]; then
		staaaaat;
	fi
	rm -f $fhome"input2send.txt"
done

#echo > $fhome$lego"0.txt"
fi
}


silent_mode ()
{
silent_mode="off"
if [ "$sm" == "1" ]; then
		mdt1=$(date '+%H:%M:%S' | sed 's/\://g' | tr -d '\r')
		if [ "$mdt1" \> "$mdt_start" ] && [ "$mdt1" \< "$mdt_end" ]; then
			silent_mode="on"
		fi
fi
logger "silent_mode="$silent_mode
}



Init2;
if ! [ -f $fPID ]; then
PID=$$
echo $PID > $fPID
logger "start"

#del old logs
rm -d $fhomes
rm -d $fhomet
rm -d $fhomePD

starten_furer;

$fhome"sender.sh" &

[ "$start2" == "1" ] && bic="0" && otv=$fhome"start.txt" && send;

kkik=0
touch $fhome"in_id0.txt"
touch $fhome"out_id0.txt"

while true
do
sec4=$(sed -n "8p" $ftb"settings.conf" | tr -d '\r')
sleep $sec4
ffufuf1=0


lego="in_id"; bic="1"; input2;
lego="out_id"; bic="2"; input2;
input;
[ "$?" -eq "1" ] && parce;

kkik=$(($kkik+1))
[ "$kkik" -eq "$progons" ] && Init2

done


else 
	logger "pid up exit"

fi


rm -f $fPID
kill -9 $(sed -n "8p" $ftb"sender_pid.txt" | tr -d '\r')
rm -f $ftb"sender_pid.txt"

