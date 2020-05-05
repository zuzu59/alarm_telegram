#!/bin/bash
#Petit script pour récupérer facilement l'id des groupes Telegram dont le bot fait partie 
#zf200505.1124

#Usage:
#./get_groupid.sh

source $(/usr/bin/dirname $0)/secrets_alarm_telegram.sh

curl https://api.telegram.org/bot$alarm_telegram_zf_token/getUpdates |grep 'id":-' | awk -F\: '{print $12 $11}'

