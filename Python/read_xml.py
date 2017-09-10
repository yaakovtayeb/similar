from bs4 import BeautifulSoup
xmldoc = '.\Files\Sites.xml'
with open(xmldoc) as fp:
    soup = BeautifulSoup(fp, 'xml')

n=0
adnetworks = soup.find("source", {"id":4})
for source in adnetworks.children:
    try:
        print(source.attrs['name'])
        n+=1
    except:
        pass
print(n)

