import requests
from bs4 import BeautifulSoup
import urlparse
import urllib

def onlyMainDomain(pages, url):
    url = urlparse.urlparse(url).netloc.replace("www.", "")
    cleanlist = []
    for page in pages:
        if url in urlparse.urlparse(page).netloc:
            cleanlist.append(page)
    return cleanlist

def findGA(url):
    url = "http://www.hatzur.org"
    htmltext = urllib.urlopen(url).read()
    soup = BeautifulSoup(htmltext, "lxml")
    scripts = soup.find_all('script')
    id = []
    found = False
    for script in scripts:
        if script.find('https://www.google-analytics.com/analytics.js'):


    print(js_text)

def get_domain(page_url):
    parsed_uri = urlparse.urlparse(page_url)
    domain = parsed_uri.scheme + '://' + parsed_uri.netloc + '/'
    return domain

def get_links(page_url):
    htmltext = urllib.urlopen(page_url).read()
    soup = BeautifulSoup(htmltext, "lxml")
    domain = get_domain(page_url)
    urls_in_page = []
    for tag in soup.find_all('a', href=True):
        urls_in_page.append(urlparse.urljoin(domain, tag['href']))
    print list(set(urls_in_page))

def main():
    url = "http://www.hatzur.org/"
    get_links(url)

if __name__ == "__main__":
    main()




