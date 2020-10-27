'''Just a little script I wrote to grab all images from a 4chan thread. Gets the full-res image, handles existing filenames so I could run it later to get the newest images. Works like "python 4chan.py <url> <folder>" so "./4chan.py http://boards.4chan.org/wg/res/4836807 wp-nature" would get me a bunch of hi-res nature wallpapers.'''

import os
import sys
import urllib
import urllib2
import re
import time

if not len(sys.argv) >= 3:
    print "Missing parameters."
    print "Usage:    python 4chan.py <url> <folder>"
    sys.exit()

threadurl = sys.argv[1]
subfolder = sys.argv[2]

exp_imgurl = re.compile('4chan\.org/\w+/src/\d+\.(?:jpg|gif|png|jpeg)')
exp_picname = re.compile('\d+\.(?:jpg|gif|png|jpeg)')

ua = "Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.9.1.4) Gecko/20091007 Firefox/3.5.4"
head = {'User-agent': ua}

print "Thread %s going to folder %s" % (threadurl, subfolder)

print "Fetching html..."

req = urllib2.Request(threadurl, None, head)
try:
    response = urllib2.urlopen(req)
except urllib2.HTTPError, e:
    if errorcount < 1:
        errorcount = 1
        print "Request failed"
        response = urllib2.urlopen(req)
except urllib2.URLError, e:
    if errorcount < 1:
        errorcount = 1
        print "Request failed"
        response = urllib2.urlopen(req)

msg = response.read()
errorcount = 0

print "Received %d bytes" % len(msg)

imgurls = exp_imgurl.findall(msg)

print "Found %d images" % len(imgurls)

if not os.path.exists(subfolder):
    print "Folder %s does not exist. Creating..." % subfolder
    os.makedirs(subfolder)
else:
    print "Folder %s exists. I will just put all files in there." % subfolder

totalnumber = len(list(set(imgurls)))

for i, img in enumerate(list(set(imgurls))):
    source = "http://images."+str(img)
    filename = exp_picname.findall(source)[0]
    destination = os.path.join(subfolder, filename)
    if not os.path.isfile(destination):
        try:
            print "Downloading %d/%d: %s" % (i+1, totalnumber, source)
            urllib.urlretrieve(source, destination)
            time.sleep(0.25)  # why?
        except urllib.ContentTooShortError:
            print "Image download failed, retrying..."
            time.sleep(1)
            urllib.urlretrieve(source, destination)
            time.sleep(0.5)  # why?
    else:
        print "File %s exists. Skipping..." % str(filename)

print "Aaaaaaand we are done. See you next time."
