# alarm_telegram
Petit projet d'envois d'alarmes sur Telegram
zf200501.2035

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [alarm_telegram](#alarmtelegram)
- [Buts](#buts)
- [Problématiques](#problmatiques)
- [Moyens](#moyens)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Sources](#sources)

<!-- /TOC -->

# Buts

Envoyer très simplement un message sur Telegram quand une valeur est hors consigne.

Le but ici est de faire un système très simple, pas une *usine à gaz*, afin de pouvoir justement *dédoubler* l'usine à gaz dans le cas où elle ne fonctionne plus !


# Problématiques

Pour pouvoir envoyer un message sur Telegram, il faut avoir un *token* et autoriser la *réception* depuis ce token. Ce *token* est bien entendu confidentiel, il ne doit pas se trouver sur *Github*, il faut donc un système de protection de ce token


# Moyens

Un *bash script*, qui est lancé par un *crontab* à intervalles réguliers, scrute une *valeur* et envoie un message sur Telegram si la *consigne* a été dépassée.

Pour la protection du token, c'est *Keybase* qui sera utilisé. mais *keybase* ne va pas tourner sur les serveurs ou raspis car c'est des *scripts* lancés par le *crontab*. Il faudra donc les sauvegarder dans un fichier de *secrets* sur la machine et le protéger en conséquence.


# Installation
Pour pouvoir *lire* la température en ligne de commande sur MAC OS il faut installer *istats* avec:
```
sudo gem install iStats
```
puis la lire avec:
```
istats cpu temp  | awk '{print $3}' | sed "s/°C//g"
```

Pour pouvoir *envoyer* des alarmes sur Telegram depuis le *crontab* il faut copier le fichier des *secrets* dans le dossier des scripts:
```
cp /keybase/private/zuzu59/secrets_alarm_telegram_zf.sh .
```


# Utilisation
Pour tester en temps réel les envois on peut faire:
```
watch './alarm_temp_macos.sh'
```
Puis en *stressant* le CPU dans une autre console avec:
```
yes >/dev/null
```
Pour l'utiliser après en tâche de fond, il faut le mettre dans le *crontab*:
```
crontab -e
```
```
* * * * * /Users/zuzu/dev-zf/alarm_telegram/alarm_temp_macos.sh
```


# Sources

https://thingsboard.io/docs/iot-gateway/integration-with-telegram-bot/
https://apple.stackexchange.com/questions/54329/can-i-get-the-cpu-temperature-and-fan-speed-from-the-command-line-in-os-x
https://github.com/Chris911/iStats




