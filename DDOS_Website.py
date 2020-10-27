import splinter
import time
import threading
from random import randrange
from random import shuffle

# Note that the following are all HTTPS proxies:
# onbtainted from http://proxylist.hidemyass.com/search-1797031#listable   and   http://www.freeproxylists.net/?c=&pt=&pr=HTTPS&a%5B%5D=1&a%5B%5D=2&u=0
proxy_pool = {'202.231.218.217': 3128, '202.152.162.124': 80, '202.159.42.246': 80, '123.206.70.182': 80, '84.23.107.195': 8080, '43.226.162.110': 8080, '144.76.198.114': 3128, '149.202.249.227': 3128, '115.113.43.215': 80, '203.66.159.46': 3128, '203.66.159.45': 3128, '203.66.159.44': 3128, '158.69.237.1': 3128, '212.38.166.231': 443, '222.81.61.29': 808, '124.47.7.45': 80, '117.184.117.229': 3128, '43.226.162.107': 8080, '61.164.0.212': 8080, '31.207.0.99': 3128, '137.135.166.225': 8147, '144.76.178.81': 3128, '101.226.249.237': 80, '139.255.39.147': 8080, '146.185.253.241': 3128, '189.90.244.73': 8080, '201.245.205.229': 3128, '119.188.94.145': 80, '31.131.67.76': 8080, '212.175.249.171': 80, '112.23.1.167': 8080, '46.97.103.50': 3128, '60.169.78.218': 808, '115.146.123.219': 8080, '189.28.166.79': 80, '46.228.204.172': 8080, '94.23.234.179': 8585, '61.8.35.136': 8088, '125.212.217.215': 80, '218.89.38.21': 808, '31.173.74.73': 8080, '46.236.216.241': 8080, '201.86.232.87': 8080, '222.124.194.171': 3128, '202.77.57.124': 3128, '146.184.0.116': 80, '146.184.0.115': 8080, '202.99.29.102': 80, '31.168.236.236': 8080, '109.63.199.116': 3128, '110.36.184.209': 3128,
              '194.149.64.19': 3128, '134.87.187.99': 8080, '223.31.54.245': 8080, '68.227.39.95': 3128, '81.21.77.172': 8083, '164.132.11.206': 3128, '222.82.222.242': 9999, '46.167.210.2': 8118, '113.161.197.128': 80, '62.194.84.12': 80, '120.203.7.246': 80, '77.81.232.85': 80, '182.180.154.47': 3128, '190.128.162.58': 80, '106.249.176.213': 80, '119.93.82.148': 80, '219.255.197.90': 3128, '52.11.31.207': 4444, '119.85.189.111': 8998, '213.129.39.227': 3128, '61.8.35.167': 8088, '121.22.252.241': 8080, '89.108.165.187': 8080, '89.36.210.173': 80, '122.226.166.231': 8080, '89.166.47.129': 3128, '88.80.16.87': 80, '92.222.107.181': 3128, '69.20.115.81': 80, '190.199.99.52': 8080, '168.63.24.174': 8127, '217.170.197.99': 3128, '46.173.188.103': 3128, '121.40.108.76': 80, '124.160.127.102': 8000, '92.51.133.3': 3128, '163.25.6.40': 80, '122.53.178.100': 6588, '110.182.116.42': 8118, '211.110.127.210': 3128, '64.103.27.184': 8080, '50.30.152.130': 8086, '200.140.199.170': 3130, '149.91.80.231': 8080, '121.22.252.248': 8080, '180.76.135.145': 3128, '222.176.112.31': 80, '189.28.176.253': 8080, '117.218.50.134': 6588, '112.124.113.155': 80, '183.131.151.208': 80}


def connect_splinter_proxy(count, url, proxyIP, proxyPort, wait_on_page_time):
    wait_time = randrange(0.2*wait_on_page_time, 1.8*wait_on_page_time)
    print("Starting Browser#%s   \t@ %s:%s to URL: %s \tWait time: %s sec" %
          (count, proxyIP, proxyPort, url, wait_time))
    proxy_settings = {'network.proxy.type': 1,
                      'network.proxy.http': proxyIP,
                      'network.proxy.http_port': proxyPort,
                      'network.proxy.ssl': proxyIP,
                      'network.proxy.ssl_port': proxyPort,
                      'network.proxy.socks': proxyIP,
                      'network.proxy.socks_port': proxyPort,
                      'network.proxy.ftp': proxyIP,
                      'network.proxy.ftp_port': proxyPort
                      }
    b = splinter.Browser(profile_preferences=proxy_settings)
    b.driver.set_window_size(0, 0)
    b.visit(url)
    time.sleep(5)
    if len(b.html) < 20000:
        b.visit(url)
    time.sleep(5)
    if len(b.html) < 20000:
        b.visit(url)
    time.sleep(wait_time)  # 5 minutes to 20 minutes
    b.quit()
    print("\tClosing Browser#%s" % count)
    return


max_num_windows = 25
total_run_time = 24*3600  # continue for 24 hours
wait_on_page_time = 300
max_page_load_time = 60

threads = []
count = 1
start_time = time.time()  # UNIX time
while time.time()-start_time < total_run_time:
    print("\n\nStarting next round...\n")
    shuffled_IPs = proxy_pool.keys()
    shuffle(shuffled_IPs)
    for proxyIP in shuffled_IPs:
        if count % max_num_windows != 0:
            proxyPort = proxy_pool[proxyIP]
            # I feel a little guilty at spamming the folks over at whoer.net, but not enough to remove this line.
            url = "https://whoer.net/"
            t = threading.Thread(target=connect_splinter_proxy, args=(
                count, url, proxyIP, proxyPort, wait_on_page_time))
            # t.setDaemon(True)
            threads.append(t)
            t.start()
            count += 1
            time.sleep(max_page_load_time)

    print("\n\nWaiting for all browsers of this round to die...\n")
    time.sleep(1.5*wait_on_page_time)
