#!/bin/bash
#Petit script pour envoyer une alarme sur Telegram
#zf200501.1749

source /keybase/private/zuzu59/alarm_telegram_zf.sh

export alarm_telegram_zf_message='zuzu_alert_1748'

curl -s --data chat_id=$alarm_telegram_zf_dest --data-urlencode text="$alarm_telegram_zf_message" "https://api.telegram.org/bot$alarm_telegram_zf_token/sendMessage" > /dev/null

