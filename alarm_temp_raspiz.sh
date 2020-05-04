#!/bin/bash
#Petit script pour envoyer simplement un message sur Telegram quand la température du CPU du raspi dépasse la consigne
#Il y a aussi une détection, avec hystérèse, du retour à la normale afin d'éviter les oscillations proches de la consigne
#zf200504.0926

#Source: 
#https://debian-facile.org/doc:programmation:shells:page-man-bash-iii-les-operateurs-de-comparaison-numerique
#https://www.system-linux.eu/index.php?post/2009/01/17/Operation-mathematique-simple-avec-Bash

# lire la température sur raspi
# cat /sys/class/thermal/thermal_zone0/temp

# watch './alarm_temp_raspiz.sh'
# yes >/dev/null

#cp /keybase/private/zuzu59/secrets_alarm_telegram_zf.sh .
#crontab -e
#* * * * * /home/pi/alarm_telegram/alarm_temp_raspiz.sh

#ZVAL=$(/usr/local/bin/istats cpu temp  | /usr/bin/awk '{print $3}' | /usr/bin/sed "s/°C//g")
ZVAL=`echo "scale=2;$(cat /sys/class/thermal/thermal_zone0/temp)/1000" | /usr/bin/bc -l`
ZCONSIGN_ON=70.0
ZHYSTERESE=3.0
ZCONSIGN_OFF=`echo "$ZCONSIGN_ON-$ZHYSTERESE" | /usr/bin/bc -l`
ZFLAG=/tmp/alarm_temp.txt
echo $ZVAL

if (( $(echo "$ZVAL > $ZCONSIGN_ON" | /usr/bin/bc -l) )) ; then
  if [[ -f $ZFLAG ]] ; then
    echo "Alarm déjà envoyée"
  else
    /usr/bin/touch $ZFLAG
    echo "Alarm, alarm, c'est trop chaud !"
    $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'Raspiz, alarme température CPU, '$ZVAL'°C'
  fi
else
  if (( $(echo "$ZVAL < $ZCONSIGN_OFF" | /usr/bin/bc -l) )) ; then
    if [[ -f $ZFLAG ]] ; then
      rm $ZFLAG
      echo "retour à la normale !"
      $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'Raspiz, retour à la normale CPU, '$ZVAL'°C'
    fi
  fi
  echo "c'est tout ok !"
fi
