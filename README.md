# zabbix telegram bot
  
install from root  
cd /usr/share/zabbix/local && git clone https://github.com/Evonic4/zabbix_telegram_bot.git && chown -R zabbix:zabbix /usr/share/zabbix/local/trbot/ && cp -r -f ./logrotate /etc/logrotate.d/ && chmod +rx /usr/share/zabbix/local/trbot/setup.sh && /usr/share/zabbix/local/trbot/setup.sh  
  
settings in zabbix server:  
  ---
![image](https://user-images.githubusercontent.com/46780974/129004502-ef5a25a9-6095-40c2-8209-9be9e7137fa5.png)  
  
![image](https://user-images.githubusercontent.com/46780974/129004677-80abd0db-bf80-4290-a387-81b044ddf783.png)
  
settings:  
/usr/share/zabbix/local/trbot/settings.conf  
  
start:  
su zabbix -c '/usr/share/zabbix/local/trbot/trbot.sh' -s /bin/bash  
  
log:  
/var/log/trbot/trbot.log  
  
  
