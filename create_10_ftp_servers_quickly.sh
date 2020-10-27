#!/bin/bash

# Depends on Environment Variable ${FTP_USER} and ${FTP_PASS} to be defined
# before running this script, if so comment out the following 2 lines
FTP_USER=default_user
FTP_PASS=default_pass

for FTP_NO in `seq 1 10`;
do
    mkdir -p ~/Downloads/ftp_servers/ftp${FTP_NO}/
    cd ~/Downloads/ftp_servers/ftp${FTP_NO}/
    echo Provisioning FTP server ${FTP_NO}
    
    sudo docker run -it -d \
    -e USER=${FTP_USER} \
    -e PASS=${FTP_PASS} \
    -p $((2000+FTP_NO)):22 \
    -v /home/dean/Downloads/ftp_servers/ftp${FTP_NO}/:/mnt \
    --name=ftp${FTP_NO} \
    luzifer/sftp-share
    
    ftp_pid=`sudo docker inspect --format '{{ .State.Pid }}' ftp${FTP_NO}`
    ftp_ip=`sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ftp${FTP_NO}`
    echo Provisioned FTP server with docker container id: ${ftp_pid} \
    and IP Address: ${ftp_ip}
    sudo docker inspect ftp${FTP_NO} > ftp${FTP_NO}_details.txt
done