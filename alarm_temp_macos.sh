#!/bin/bash
#Petit script pour envoyer simplement un message sur Telegram quand la température du CPU du MAC dépasse la consigne
#Il y a aussi une détection, avec hystérèse, du retour à la normale afin d'éviter les oscillations proches de la consigne
#zf200502.1204

#Source: 
#https://debian-facile.org/doc:programmation:shells:page-man-bash-iii-les-operateurs-de-comparaison-numerique
#https://www.system-linux.eu/index.php?post/2009/01/17/Operation-mathematique-simple-avec-Bash

# lire la température sur MAC OS
# il faut installer istats avec:
# sudo gem install iStats
# puis la lire avec
# istats cpu temp  | awk '{print $3}' | sed "s/°C//g"

# watch -n 1 './alarm_temp_macos.sh'
# yes >/dev/null

ZVAL=$(istats cpu temp  | awk '{print $3}' | sed "s/°C//g")
ZCONSIGN_ON=60.0
ZHYSTERESE=4.0
ZCONSIGN_OFF=`echo "$ZCONSIGN_ON-$ZHYSTERESE" | bc -l`

echo $ZVAL

if (( $(echo "$ZVAL > $ZCONSIGN_ON" | bc -l) )) ; then
  if [[ -f /tmp/toto.txt ]] ; then
    echo "Alarm déjà envoyée"
  else
    touch /tmp/toto.txt
    echo "Alarm, alarm, c'est trop chaud !"
    ./send_alarm_telegram.sh 'Macbookprozf, alarme température CPU, '$ZVAL'°C'
    Alarm, alarm, c'\''est trop chaud !'
  fi
else
  if (( $(echo "$ZVAL < $ZCONSIGN_OFF" | bc -l) )) ; then
    if [[ -f /tmp/toto.txt ]] ; then
      rm /tmp/toto.txt
      echo "retour à la normale !"
      ./send_alarm_telegram.sh 'Macbookprozf, retour à la normale CPU, '$ZVAL'°C'
    fi
  fi
  echo "c'est tout ok !"
fi


