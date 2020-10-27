#!/bin/bash

### Block all traffic from -----> Use ISO code ###
ISO="cn"
### Set PATH ###
IPT=/sbin/iptables

wget -nv http://www.ipdeny.com/ipblocks/data/countries/all-zones.tar.gz
tar -zxvf all-zones.tar.gz

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -I PREROUTING 1 -j LOG
iptables -t nat -I POSTROUTING 1 -j LOG
iptables -t nat -I OUTPUT 1 -j LOG

cleanOldRules(){
    $IPT -F
    $IPT -X
    $IPT -t nat -F
    $IPT -t nat -X
    $IPT -t mangle -F
    $IPT -t mangle -X
    $IPT -P INPUT ACCEPT
    $IPT -P OUTPUT ACCEPT
    $IPT -P FORWARD ACCEPT
}

# clean old rules
cleanOldRules

for c  in $ISO
do
    for x in $(cat $c.zone)
    do
        prips $x >> tmp.txt 2>&1
        echo "DEBUG:" $x "extracting ... then onto the next"
        #iptables -A INPUT -s $x -j DROP
    done
done

echo "Fin"
echo "Onto the next bit, Setting up NAT in IPTables"

cat tmp.txt | while read LINE
do
    
    #echo "DEBUG:Creating IP Table Rule :- iptables -A INPUT -s" $LINE "-j DROP"
    #iptables -A INPUT -s $LINE -j DROP LOG --log-prefix "iptables Denied by JAMIE_SCRIPT: " --log-level 7
    
    echo "DEBUG: Dropping and Logging" $LINE
    
    iptables -A INPUT -s $LINE -j LOG --log-prefix "STOP_d: " --log-level 7
    iptables -A INPUT -s $LINE -j DROP
    
    #echo "DEBUG:iptables -t nat -A OUTPUT -d" $LINE "-j DNAT --to-destination" $LINE
    #iptables -t nat -A OUTPUT -d $LINE -j DNAT --to-destination $LINE
done

echo "Done, Housekeeping..."

rm *.zone

http://tgtechnotes.blogspot.co.uk/