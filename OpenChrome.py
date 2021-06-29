import webbrowser

websites = ['https://www.google.com/','https://www.gmail.com/']
webbrowser.register('chrome',None,webbrowser.BackgroundBrowser("C:/Program Files/Google/Chrome/Application/chrome.exe"))
for url in websites:
    webbrowser.get('chrome').open(url)

