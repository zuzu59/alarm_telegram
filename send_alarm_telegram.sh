#!/bin/bash
#Petit script pour envoyer une alarme sur Telegram
#zf200506.0902

#Usage:
#./send_alarm_telegram.sh 'alarme feu'

source $(/usr/bin/dirname $0)/secrets_alarm_telegram.sh

export alarm_telegram_zf_message='zuzu_alert-175350'

#curl -s --data chat_id=$alarm_telegram_zf_dest --data-urlencode text="$alarm_telegram_zf_message" "https://api.telegram.org/bot$alarm_telegram_zf_token/sendMessage" > /dev/null
/usr/bin/curl -s --data chat_id=$alarm_telegram_dest1 --data-urlencode text="$1" "https://api.telegram.org/bot$alarm_telegram_token/sendMessage" > /dev/null
/usr/bin/curl -s --data chat_id=$alarm_telegram_dest2 --data-urlencode text="$1" "https://api.telegram.org/bot$alarm_telegram_token/sendMessage" > /dev/null

