#!/usr/bin/env python3

import requests
from requests import get
import bs4
import re
import time
import os

def download(url, file_name):
    if os.path.isfile(file_name):
        print('skipping ' + file_name + '...')
        return(True)
    connected = False
    tries_2 = 0
    while not connected:
         try:
             response = get(url)
             with open(file_name, 'wb') as file:
                 file.write(response.content)
             print('downloaded ' + str(num) + '\r\n')
             connected = True
         except:
             tries_2 = tries_2 + 1
             if tries_2 == 11:
                 connected = True
             else:
                 print('retrying ' + str(tries_2) + ' ' + url + '...')
                 time.sleep(10)
             pass

for num in range(0, 100000):
    start_url = "http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.htm&r=" + str(num) + "&f=G&l=50&d=PTXT&p=1&S1=microsoft.ASNM.&OS=AN/microsoft&RS=AN/microsoft"
    headers = {'User-Agent':'HTC Mozilla/5.0 (Linux; Android 7.0; HTC 10 Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.83 Mobile Safari/537.36.'}

    connected = False
    tries = 0
    while not connected:
        try:
            content = requests.get(start_url,headers=headers)
            soup = bs4.BeautifulSoup(content.text,features='lxml')
            for t in soup.find_all('a', href=lambda x: x and 'View+first+page' in x):
                step2 = t['href'] + '&pagenum=0'
            sec_content = requests.get(step2)
            soup2 = bs4.BeautifulSoup(sec_content.text,features='lxml')
            download('http:' + soup2.find('embed').get('src'), soup2.find('embed').get('name') + '.pdf')
            connected = True
        except:
            tries = tries + 1
            if tries == 11:
                connected = True
            else:
                print('retrying ' + str(tries) + ' ' + start_url + '...')
                time.sleep(10)
            pass
