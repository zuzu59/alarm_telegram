#!/bin/bash
# Petit script pour envoyer simplement un message sur Telegram quand le quota pour les images de la caméra est dépassé !
# Ce n'est donc pas la place disque restante qui est sous moniteur mais la place occupée par les images, différent que d'habitude !
# Il y a aussi une détection, avec hystérèse, du retour à la normale afin d'éviter les oscillations proches de la consigne
# zf200501.1701, zf231211.2051, zf241031.1531, zf250329.1821

#Source: 
#https://debian-facile.org/doc:programmation:shells:page-man-bash-iii-les-operateurs-de-comparaison-numerique
#https://www.system-linux.eu/index.php?post/2009/01/17/Operation-mathematique-simple-avec-Bash


# watch -n 3 './alarm_disque_noc-test.sh'
# dd if=/dev/zero of=bigfile1 bs=1M count=1000

#cp /keybase/private/zuzu59/secrets_alarm_telegram_zf.sh .
#crontab -e
#* * * * * /home/ubuntu/dev/alarm_telegram/alarm_disque_zuzu-test.sh > /dev/null 2>&1 || true

#ZVAL=$(/usr/local/bin/istats cpu temp  | /usr/bin/awk '{print $3}' | /usr/bin/sed "s/°C//g")
#ZVAL=`echo "scale=2;$(cat /sys/class/thermal/thermal_zone0/temp)/1000" | /usr/bin/bc -l`
#ZVAL=$(/bin/df -k |/bin/grep '/dev/vda1 ' |/usr/bin/awk '{print $4}')
ZVAL=$(/bin/du -b -d 0 /mnt/data/ | /usr/bin/awk '{print $1}')

# Donc ce n'est PAS la place restante sur le disque mais le quota autorisé pour les images !
ZCONSIGN_ON=15800000000
ZHYSTERESE=1000
ZCONSIGN_OFF=`echo "$ZCONSIGN_ON-$ZHYSTERESE" | /usr/bin/bc -l`
ZFLAG=/tmp/alarm_disk.txt
echo -e "ZVAL (actuellement utilisé):  " $ZVAL
echo -e "ZCONSIGN_ON (quota autorisé): " $ZCONSIGN_ON

RESTE=$( echo "$ZCONSIGN_ON - $ZVAL" | /usr/bin/bc)
echo -e "Reste encore: " $RESTE



if (( $(echo "$ZVAL > $ZCONSIGN_ON" | /usr/bin/bc -l) )) ; then
  if [[ -f $ZFLAG ]] ; then
    echo "Alarme déjà envoyée"
  else
    /usr/bin/touch $ZFLAG
    echo "Alarme, alarme, y'a presque plus de place disque !"
#    $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'NOC-tst, alarme manque place disque, '$ZVAL'kB' zf
    $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'zuzu-test, alarme manque place disque, '$RESTE' Bytes' ctrl_alrm_zf
#    $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'NOC-tst, alarme manque place disque, '$ZVAL'kB' ctrl_alrm_noc
  fi
else
#  if (( $(echo "$ZVAL > $ZCONSIGN_OFF" | /usr/bin/bc -l) )) ; then
    if [[ -f $ZFLAG ]] ; then
      rm $ZFLAG
      echo "retour à la normale !"
#      $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'NOC-tst, retour à la normale, '$ZVAL'kB' zf
      $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'zuzu-test, retour à la normale, '$RESTE' Bytes' ctrl_alrm_zf
#      $(/usr/bin/dirname $0)/send_alarm_telegram.sh 'NOC-tst, retour à la normale, '$ZVAL'kB' ctrl_alrm_noc
    fi
#  fi
  echo "c'est tout ok !"
fi
