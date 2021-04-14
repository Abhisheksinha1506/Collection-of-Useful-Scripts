#!/bin/bash

# Author: Ziyad Yehia
# Created: 7th July 2020
# Last Modified: 7th July 2020

# Description:
# Creates a backup in the current directory of
# all files in the home directory

echo "Hello there, ${USER^}"
echo "I will now back up your home directory, $HOME"

currentdir=$(pwd)

echo "I will create save the backup file in $currentdir"

tar -cf "$currentdir/my_backup_$(date +%d-%m-%Y_%H-%M-%S).tar" $HOME 2>/dev/null

echo "Backup completed successfully"

exit 0
