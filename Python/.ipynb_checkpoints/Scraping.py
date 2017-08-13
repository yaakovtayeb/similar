import requests
from bs4 import BeautifulSoup
from urlparse import urlparse
import pandas as pd

def getlinks(url):
    page = requests.get(url)
    if page.status_code == 200:
        soup = BeautifulSoup(page.content, 'html.parser')
        links = []
        for l in soup.find_all('a'):
            link = l.get('href')
            try:
                link = urlparse(url).scheme + "://" + urlparse(url).netloc + urlparse(url).path.replace(urlparse(url).path.split("/")[len(urlparse(url).path.split("/"))-1], "") + "/" + l.get('href') if link.find("http") == -1 else l.get('href')
                link = link[0:7] + link[7:len(link)].replace("//", "/") # remove double // for sites href with "/"
                links.append(link)
            except: pass
        return list(set(links))
    else:
        return []

def onlyMainSite(links, mainsite):
    sites=[]
    for l in links:
        beg = l.find("//")+2
        end = l.find("/", beg) if l.find("/", beg) > -1 else len(l)
        if l[beg:end].find(mainsite)>-1 & l.find("..") == -1 :
           sites.append(l)
    return sites

def crawler(url, maindomain):
    links = []
    pagelinks = onlyMainSite(getlinks(url), maindomain)
    links.extend(pagelinks)
    i = 0
    while len(links)> i:
        pagelinks = onlyMainSite(getlinks(links[i]), maindomain)
        links.extend(list(set(pagelinks)-set(links)))
        i+=1
        print("current page %d - Total: %d" % (i, len(links)))
    return links

def checkGA(urls, gascript):
    status = []
    for url in urls:
        page = requests.get(url)
        if page.status_code == 200:
            status.append(0) if page.content.find(gascript) == -1 else status.append(1)
        else:
            status.append(page.status_code)
    return status

pages = crawler("http://www.espn.com", "espn.com")
script = "gads.src = 'https://www.googletagservices.com/tag/js/gpt.js'"
status = checkGA(pages, script)
data = pd.DataFrame({'pages': pages, 'status': status})

print(pages)