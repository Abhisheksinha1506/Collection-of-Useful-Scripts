#!/bin/bash

if ! grep -q backup=true.* "~/.myconfig"
then
  echo 'Backup not enabled in $HOME/.myconfig, exiting'
  exit 1
fi

tar -cf  “$1/my_backup_$(date +%d-%m-%Y_%H-%M-%S).tar” "$HOME"