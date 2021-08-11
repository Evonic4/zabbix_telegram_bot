#!/bin/bash

home_trbot=/usr/share/zabbix/local/trbot/
prob=$home_trbot"in_id1.txt"
res=$home_trbot"out_id1.txt"

cp -f $home_trbot"in_id.txt" $prob
cp -f $home_trbot"out_id.txt" $res

vjob=$home_trbot"job.txt"
rm -f $vjob && touch $vjob


str_col=$(grep -cv "^#" $prob)
echo "str_col="$str_col

for (( i=1;i<=$str_col;i++)); do
test=$(sed -n $i"p" $prob | tr -d '\r')
test_id=$(echo $test | awk '{print $3}')
echo "test_id="$test_id
	if ! [ "$(grep $test_id $res)" ]; then
		echo $test >> $vjob		
		#i1++
		echo "to job"
	fi
done

sed -e '/^\s*$/d' $vjob > $home_trbot"job1.txt"
cp -f $home_trbot"job1.txt" $vjob
cp -f $home_trbot"job1.txt" $home_trbot"in_id.txt"

rm -f $home_trbot"out_id.txt"
touch $home_trbot"out_id.txt"
chown -R zabbix /usr/share/zabbix/local/trbot/

echo "----" >> $vjob

cat $vjob

