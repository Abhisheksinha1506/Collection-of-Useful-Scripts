import requests
from bs4 import BeautifulSoup
import pandas as pd
final_list=[]
for i in range(1920,2024):
   try:
      url = 'https://www.planecrashinfo.com/{}/{}.htm'.format(i,i)
      print(url)
      response = requests.get(url)
      html_content = response.content
      df_list = pd.read_html(html_content)
      df = df_list[-1]
      final_list.append(df)
   except:
        print("Incorrect",url)
        continue
print(final_list)
print(len(final_list))
merge = pd.concat(final_list)
merge.to_csv('final.csv')

