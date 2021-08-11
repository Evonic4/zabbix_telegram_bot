#!/bin/bash

home_trbot=/usr/share/zabbix/local/trbot/
#iter=$(echo $1 | awk '{print $2}')
iter=$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8

echo $iter | tr " " "\n" > $home_trbot"temp_del.txt"


function deleteler()
{
[ "$test" == "all" ] && grep -v '^#' $home_trbot"in_id.txt" >> $home_trbot"delete_id.txt" && touch $home_trbot"in_id2.txt" && cp -f $home_trbot"in_id2.txt" $home_trbot"in_id.txt" && echo $test" check" && echo "delete all ok" > $home_trbot"del.txt" && exit 0

grep $test $home_trbot"in_id.txt" >> $home_trbot"delete_id.txt"
cp -f $home_trbot"in_id.txt" $home_trbot"in_id2.txt"
grep -v $test $home_trbot"in_id2.txt" > $home_trbot"in_id.txt"
echo $test" check"
}

str_col=$(grep -cv "^#" $home_trbot"temp_del.txt")
echo "str_col="$str_col

for (( i=1;i<=$str_col;i++)); do
	rm -f $home_trbot"in_id2.txt"
	test=$(sed -n $i"p" $home_trbot"temp_del.txt" | tr -d '\r')
	echo "del_id="$test
	deleteler;
done

echo "delete ok, jobs now:" > $home_trbot"del.txt"
cat $home_trbot"in_id.txt" >> $home_trbot"del.txt"
echo "----" >> $home_trbot"del.txt"
