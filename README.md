# alarm_telegram
Petit projet d'envois d'alarmes sur Telegram
zf200501.1545

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [alarm_telegram](#alarmtelegram)
- [Buts](#buts)
- [Problématiques](#problmatiques)
- [Moyens](#moyens)
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


# Sources

https://thingsboard.io/docs/iot-gateway/integration-with-telegram-bot/




