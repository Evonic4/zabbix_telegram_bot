#!/bin/bash

f1=/usr/share/zabbix/local/trbot/

p1=$(sed -n 1"p" $f1"rtb_pid.txt" | tr -d '\r')
kill -9 $p1

p2=$(sed -n 1"p" $f1"sender_pid.txt" | tr -d '\r')
kill -9 $p2
