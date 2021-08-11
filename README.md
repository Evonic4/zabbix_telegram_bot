# zabbix telegram bot
  
install from root  
cd /usr/share/zabbix/local && git clone https://github.com/Evonic4/zabbix_telegram_bot.git && chown -R zabbix:zabbix /usr/share/zabbix/local/trbot/ && cp -r -f ./logrotate /etc/logrotate.d/ && chmod +rx /usr/share/zabbix/local/trbot/setup.sh && /usr/share/zabbix/local/trbot/setup.sh  
  
settings in zabbix server:  
  ---
  
settings:  
/usr/share/zabbix/local/trbot/settings.conf  
  
start:  
su zabbix -c '/usr/share/zabbix/local/trbot/trbot.sh' -s /bin/bash  
  
log:  
/var/log/trbot/trbot.log  
  
  