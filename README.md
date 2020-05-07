# alarm_telegram
Envois, de manière simple, des message d'alarmes sur Telegram<br>
zf200507.1851

<!-- TOC titleSize:2 tabSpaces:2 depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 skip:1 title:1 charForUnorderedList:* -->
## Table of Contents
* [Buts](#buts)
* [Problématiques](#problématiques)
* [Moyens](#moyens)
* [Installation](#installation)
  * [Configuration de Telegram](#configuration-de-telegram)
* [Utilisation](#utilisation)
  * [Envoi de messages sur Telegram via un script bash](#envoi-de-messages-sur-telegram-via-un-script-bash)
  * [Alarmes température sur raspis](#alarmes-température-sur-raspis)
  * [Alarmes température sur MAC](#alarmes-température-sur-mac)
  * [Alarmes disque sur NOC-test](#alarmes-disque-sur-noc-test)
* [Sources](#sources)
<!-- /TOC -->

<br><br><center>![Image](https://raw.githubusercontent.com/zuzu59/alarm_telegram/master/img/icone_alarm_small.jpg)</center>

# Buts

Envoyer très simplement un message sur Telegram quand une valeur est hors consigne.

Le but ici est de faire un système très simple, pas une *usine à gaz*, afin de pouvoir justement *dédoubler* l'usine à gaz dans le cas où elle ne fonctionnerait plus !


# Problématiques

Pour pouvoir envoyer un message sur Telegram, il faut avoir un *token* et autoriser la *réception* depuis ce token. Ce *token* est bien entendu confidentiel, il ne doit pas se trouver sur *Github*, il faut donc un système de protection de ce token


# Moyens

Un *bash script*, qui est lancé par un *crontab* à intervalles réguliers, scrute une *valeur* et envoie un message sur Telegram si la *consigne* a été dépassée.

Pour la protection du token, c'est *Keybase* qui sera utilisé. mais *Keybase* ne va pas tourner sur les serveurs ou raspis car c'est des *scripts* lancés par le *crontab*. Il faudra donc les sauvegarder dans un fichier de *secrets* sur la machine et le protéger en conséquence.


# Installation

Pour pouvoir *envoyer* des alarmes sur Telegram depuis le *crontab* il faut créer le fichier des *secrets* sur Keybase avec les bons secrets:
```
secrets_alarm_telegram_zf.sh
```
puis le copier dans le dossier des scripts *alarm_telegram* sur la machine remote:
```
cp /keybase/private/zuzu59/secrets_alarm_telegram_zf.sh .
```
Pour tester le bon fonctionnement d'envoi d'alarmes sur Telegram on peut faire:
```
./send_alarm_telegram.sh 'alarme feu'
```

## Configuration de Telegram

Tout se trouve dans ma petite documentation:

*Envoyer des messages sur Telegram avec un script bash, mais c'est si simple ;-)*

https://drive.google.com/open?id=11JITUwK1ZX5A7dJ1GbhYlZk0-kKJPM1BUL9qpyYDjfs


# Utilisation

## Envoi de messages sur Telegram via un script bash

On peut maintenant envoyer très facilement un *message* sur Telegram avec ce script bash:
```
./send_alarm_telegram.sh 'alarme feu' <suffixe xxx du destinataire (alarm_telegram_dest_xxx)>
```
Donc pour le destinataire zf:
```
./send_alarm_telegram.sh 'alarme feu' zf
```
ou pour le destinataire Centrale d'alarmes zf:
```
./send_alarm_telegram.sh 'alarme feu' ctrl_alrm_zf
```
Les destinataires se trouvent dans le fichier des *secrets*:
```
secrets_alarm_telegram.sh
```
**ATTENTION:** s'il le message comporte des apostrophes, il faut les emballer dans des guillemets (***apostrophe, guillemet, apostrophe, guillemet, apostrophe***):
```
./send_alarm_telegram.sh 'alarme feu, c'"'"'est trop chaud !' zf
```


## Alarmes température sur raspis

Il est très facile de *monitorer* la température d'un raspi. La température se trouve dans le fichier:
```
cat /sys/class/thermal/thermal_zone0/temp
```
Pour tester en temps réel les envois on peut faire:
```
watch './alarm_temp_raspiz.sh'
```
Puis en *stressant* le CPU dans une autre console avec:
```
yes >/dev/null
```
Pour l'utiliser après en tâche de fond, donc de vérifier les consignes toutes les minutes, il faut le mettre dans le *crontab*:
```
crontab -e
```
```
* * * * * /home/pi/alarm_telegram/alarm_temp_raspiz.sh
```

<br><center>![Image](https://raw.githubusercontent.com/zuzu59/alarm_telegram/master/img/raspi-alarm-temp.png)

Exemple de sorties d'alarmes de température sur telegram
</center>

<br><center>![Image](https://raw.githubusercontent.com/zuzu59/alarm_telegram/master/img/raspi-monitor1.png)

Affichage de la température avec le raspi-monitor lors des tests d'envoi d'alarmes de température sur Telegram
</center>


## Alarmes température sur MAC

Il est relativement facile de *monitorer* la température d'un raspi. Il faut installer *istats* avec:
```
sudo gem install iStats
```
puis la lire avec
```
istats cpu temp  | awk '{print $3}' | sed "s/°C//g"
```
Pour tester en temps réel les envois on peut faire:
```
watch './alarm_temp_macos.sh'
```
Puis en *stressant* le CPU dans une autre console avec:
```
yes >/dev/null
```
Pour l'utiliser après en tâche de fond, donc de vérifier les consignes toutes les minutes, il faut le mettre dans le *crontab*:
```
crontab -e
```
```
* * * * * /Users/zuzu/dev-zf/alarm_telegram/alarm_temp_macos.sh
```

<br><center>![Image](https://raw.githubusercontent.com/zuzu59/alarm_telegram/master/img/mac-alarm-temp.png)

Exemple de sorties d'alarmes de température sur telegram
</center>


## Alarmes disque sur NOC-test

Il est très facile de *monitorer* l'espace disque restant sur une machine Linux:
```
/bin/df -k |/bin/grep /dev/vda1 |/usr/bin/awk '{print $4}'
```
Pour tester en temps réel les envois on peut faire:
```
watch './alarm_disque_noc-test.sh
```
Puis en *stressant* le disque dans une autre console avec:
```
dd if=/dev/zero of=bigfile1 bs=1M count=1000
dd if=/dev/zero of=bigfile2 bs=1M count=1000
dd if=/dev/zero of=bigfile3 bs=1M count=1000
dd if=/dev/zero of=bigfile4 bs=1M count=1000
```
Pour l'utiliser après en tâche de fond, donc de vérifier les consignes toutes les minutes, il faut le mettre dans le *crontab*:
```
crontab -e
```
```
* * * * * /home/czufferey/alarm_telegram/alarm_disque_noc-test.sh
```

<br><center>![Image](https://raw.githubusercontent.com/zuzu59/alarm_telegram/master/img/noc-test-alarm-disk.png)

Exemple de sorties d'alarmes d'espace disque sur telegram
</center>


# Sources

https://thingsboard.io/docs/iot-gateway/integration-with-telegram-bot/
https://apple.stackexchange.com/questions/54329/can-i-get-the-cpu-temperature-and-fan-speed-from-the-command-line-in-os-x
https://github.com/Chris911/iStats




