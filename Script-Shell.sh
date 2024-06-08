#!/bin/bash

DIR_NFS="/nfs/moises"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
SERVICE="httpd"
STATUS=$(systemctl is-active $SERVICE)

if [ "$STATUS" == "active" ]; then
    MESSAGE="ONLINE"
    echo "$DATE $SERVICE $STATUS $MESSAGE" >> $DIR_NFS/online.log
else
    MESSAGE="OFFLINE"
    echo "$DATE $SERVICE $STATUS $MESSAGE" >> $DIR_NFS/offline.log
fi
sudo chmod +x /usr/local/bin/verificar_apache.sh
sudo crontab -e