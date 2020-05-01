#!/bin/bash
#Petit script de test pour tester des déclenchements d'alarmes simples en bash
#zf200501.1855

#Source: https://debian-facile.org/doc:programmation:shells:page-man-bash-iii-les-operateurs-de-comparaison-numerique

# lire la température sur MAC OS
# il faut installer istats avec:
# sudo gem install iStats
# puis la lire avec
# istats cpu temp  | awk '{print $3}' | sed "s/°C//g"

# watch -n 1 './test_alarm_numerique.sh'
# yes >/dev/null


ZVAL=$(istats cpu temp  | awk '{print $3}' | sed "s/°C//g")
ZCONSIGN=58.0




if (( $(echo "$ZVAL > $ZCONSIGN" | bc -l) )) ; then
  echo " Alarm alarm, c'est trop chaud ! "
else
  echo "c'est tout ok !"
fi
