#!/bin/bash
img=$(date '+/tmp/%N.png')
scrot -z "$@" $img >/dev/null 2>&1 || exit
res=$(curl -F c=@$img https://ptpb.pw | awk -F'url:' '{print $2}') && (printf $res | xclip; printf "\a")
notify-send `echo $res`