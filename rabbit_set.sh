#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

fhome=/usr/share/zabbix/local/trbot/
rserv=$(sed -n 19"p" $fhome"settings.conf" | tr -d '\r')
queue_in=$(sed -n 20"p" $fhome"settings.conf" | tr -d '\r')
queue_out=$(sed -n 21"p" $fhome"settings.conf" | tr -d '\r')
vhost=$(sed -n 22"p" $fhome"settings.conf" | tr -d '\r')
r_usr=$(sed -n 23"p" $fhome"settings.conf" | tr -d '\r')
r_pass=$(sed -n 24"p" $fhome"settings.conf" | tr -d '\r')

#routing_key=monit
curl -i -u $r_usr":"$r_pass -H 'content-type:application/json' -X PUT $rserv/api/exchanges/%2f/monit_in -d '{"type":"direct","auto_delete":false,"durable":true,"internal":false,"arguments":{}}'
curl -i -u $r_usr":"$r_pass -H 'content-type:application/json' -X PUT $rserv/api/exchanges/%2f/monit_out -d '{"type":"direct","auto_delete":false,"durable":true,"internal":false,"arguments":{}}'

curl -i -u $r_usr":"$r_pass -H 'content-type:application/json' -X PUT $rserv/api/queues/%2f/monit_in -d '{"auto_delete":false,"durable":true,"arguments":{}}'
curl -i -u $r_usr":"$r_pass -H 'content-type:application/json' -X PUT $rserv/api/queues/%2f/monit_out -d '{"auto_delete":false,"durable":true,"arguments":{}}'

curl -i -u $r_usr":"$r_pass -H 'content-type:application/json' -X POST $rserv/api/bindings/%2f/e/monit_in/q/monit_in -d '{"routing_key":"monit","arguments":{}}'
curl -i -u $r_usr":"$r_pass -H 'content-type:application/json' -X POST $rserv/api/bindings/%2f/e/monit_out/q/monit_out -d '{"routing_key":"monit","arguments":{}}'

