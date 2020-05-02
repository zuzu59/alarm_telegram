#!/bin/bash
#Petit script de test pour tester des déclenchements d'alarmes simples avec des consignes numériques en bash
#zf200502.1617

#Source: https://debian-facile.org/doc:programmation:shells:page-man-bash-iii-les-operateurs-de-comparaison-numerique

ZVAL=55.7
ZCONSIGN=60.0

if (( $(echo "$ZVAL > $ZCONSIGN" | bc -l) )) ; then
  echo " Alarm alarm, c'est trop chaud ! "
else
  echo "c'est ok !"
fi
