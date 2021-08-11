#!/bin/bash

token='1602469634:AAGDHsIG3zFu41APeDoojshJStEQd0-zHyg'
chat="-1001359055874"
subj="test6"
message="test6"

#/usr/bin/curl -s --header 'Content-Type: application/json' --request 'POST' --data "{\"chat_id\":\"${chat}\",\"text\":\"${subj}\n${message}\"}" "https://api.telegram.org/bot${token}/sendMessage"

#curl -E /etc/ssl/cert.crt --key /etc/ssl/cert.key -L -s -X POST https://api.telegram.org/bot$token/sendMessage -F chat_id="$chat" -F text="test7" > "out0.txt"
curl -E /etc/ssl/cert.crt --key /etc/ssl/cert.key -L https://api.telegram.org/bot$token/getUpdates > "in0.txt"
