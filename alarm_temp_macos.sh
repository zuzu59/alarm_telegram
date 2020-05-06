#!/bin/bash
#Petit script pour envoyer simplement un message sur Telegram quand la température du CPU du MAC dépasse la consigne
#Il y a aussi une détection, avec hystérèse, du retour à la normale afin d'éviter les oscillations proches de la consigne
#zf200506.1428

#Source: 
#https://debian-facile.org/doc:programmation:shells:page-man-bash-iii-les-operateurs-de-comparaison-numerique
#https://www.system-linux.eu/index.php?post/2009/01/17/Operation-mathematique-simple-avec-Bash

# lire la température sur MAC OS
# il faut installer istats avec:
# sudo gem install iStats
# puis la lire avec
# istats cpu temp  | awk '{print $3}' | sed "s/°C//g"

# watch -n 3 './alarm_temp_macos.sh'
# yes >/dev/null

#cp /keybase/private/zuzu59/secrets_alarm_telegram_zf.sh .
#crontab -e
#* * * * * /Users/zuzu/dev-zf/alarm_telegram/alarm_temp_macos.sh


ZVAL=$(/usr/local/bin/istats cpu temp  | /usr/bin/awk '{print $3}' | /usr/bin/sed "s/°C//g")
ZCONSIGN_ON=65.0
ZHYSTERESE=4.0
ZCONSIGN_OFF=`echo "$ZCONSIGN_ON-$ZHYSTERESE" | /usr/bin/bc -l`
ZFLAG=/tmp/alarm_temp.txt
echo $ZVAL

if (( $(echo "$ZVAL > $ZCONSIGN_ON" | /usr/bin/bc -l) )) ; then
  if [[ -f $ZFLAG ]] ; then
    echo "Alarm déjà envoyée"
  else
    /usr/bin/touch $ZFLAG
    echo "Alarm, alarm, c'est trop chaud !"
    $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'Macbookprozf, alarme température CPU, '$ZVAL'°C' zf
    $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'Macbookprozf, alarme température CPU, '$ZVAL'°C' ctrl_alrm_zf
  fi
else
  if (( $(echo "$ZVAL < $ZCONSIGN_OFF" | /usr/bin/bc -l) )) ; then
    if [[ -f $ZFLAG ]] ; then
      rm $ZFLAG
      echo "retour à la normale !"
      $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'Macbookprozf, retour à la normale CPU, '$ZVAL'°C' zf
      $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'Macbookprozf, retour à la normale CPU, '$ZVAL'°C' ctrl_alrm_zf
    fi
  fi
  echo "c'est tout ok !"
fi
