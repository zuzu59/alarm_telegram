#!/bin/bash
#Petit script pour envoyer une alarme sur Telegram
#zf200506.1413

#Usage:
#./send_alarm_telegram.sh 'alarme feu' [de 2 à n, rang des destinataires dans les secrets)]
#./send_alarm_telegram.sh 'alarme feu' 2

source $(/usr/bin/dirname $0)/secrets_alarm_telegram.sh > /dev/null

dest_id="alarm_telegram_dest_$2"

/usr/bin/curl -s --data chat_id=${!dest_id} --data-urlencode text="$1" "https://api.telegram.org/bot$alarm_telegram_token/sendMessage" > /dev/null

