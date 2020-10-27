#!/bin/bash

for FTP_NO in `seq 1 10`;
do
    echo Stopping FTP Server:
    sudo docker stop ftp${FTP_NO}
    echo Deleting FTP Server:
    sudo docker rm ftp${FTP_NO}
    echo Cleaning up FTP artifacts
    rm -rf ~/Downloads/ftp_servers/ftp${FTP_NO}/
done