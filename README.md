# zabbix telegram bot
  
installation on a server with zabbix from root  
cd /usr/share/zabbix/local && git clone https://github.com/Evonic4/zabbix_telegram_bot.git && chown -R zabbix:zabbix /usr/share/zabbix/local/trbot/ && cp -r -f ./logrotate /etc/logrotate.d/ && chmod +rx /usr/share/zabbix/local/trbot/setup.sh && /usr/share/zabbix/local/trbot/setup.sh  
  
  
----option 1  
settings in zabbix server:  
  ---
echo "{EVENT.SEVERITY}: ID {EVENT.ID}: {EVENT.NAME} (host={HOST.NAME}) Started at {EVENT.TIME} {EVENT.DATE}" >> /usr/share/zabbix/local/trbot/in_id0.txt  
  
![image](https://user-images.githubusercontent.com/46780974/129004502-ef5a25a9-6095-40c2-8209-9be9e7137fa5.png)  
  
echo "{EVENT.SEVERITY}: ID {EVENT.ID}: {EVENT.NAME} (host={HOST.NAME}) Resolved on {EVENT.RECOVERY.TIME} {EVENT.RECOVERY.DATE}" >> /usr/share/zabbix/local/trbot/out_id0.txt  
![image](https://user-images.githubusercontent.com/46780974/129004677-80abd0db-bf80-4290-a387-81b044ddf783.png)
  
  
----option 2 (need deployed rabbitmq)  
settings in zabbix server:  
  ---
curl -i -u user:password -H 'content-type:application/json' -X POST https://rabbitmq.yo.com:15672/api/exchanges/%2f/monit_in/publish -d '{"properties":{},"routing_key":"monit","payload":"{EVENT.SEVERITY}: ID {EVENT.ID}: {EVENT.NAME} (host={HOST.NAME}) Started at {EVENT.TIME} {EVENT.DATE}","payload_encoding":"string"}'  
  
  
curl -i -u user:password -H 'content-type:application/json' -X POST https://rabbitmq.yo.com:15672/api/exchanges/%2f/monit_out/publish -d '{"properties":{},"routing_key":"monit","payload":"{EVENT.SEVERITY}: ID {EVENT.ID}: {EVENT.NAME} (host={HOST.NAME}) Resolved on {EVENT.RECOVERY.TIME} {EVENT.RECOVERY.DATE}","payload_encoding":"string"}'  
  
![image](https://user-images.githubusercontent.com/46780974/221439911-c5c34aee-be8f-4fd3-8e2f-4e809ced996d.png)
  
----
settings:  
/usr/share/zabbix/local/trbot/settings.conf  
  
start:  
su zabbix -c '/usr/share/zabbix/local/trbot/trbot.sh' -s /bin/bash  
  
log:  
/var/log/trbot/trbot.log  
  
  
