import pandas as pd
import matplotlib.pyplot as plt

path = "C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\\next.tsv"
data = pd.read_csv(path, sep='\t', header=0) #read from file
data.columns=map(lambda x: x.replace("visits.",""), data.columns.values)
data.columns.values

data["pages"]=map(lambda x: x.replace("[",""), data["pages"])
data["pages"]=map(lambda x: x.replace("]",""), data["pages"])
data["pages"]=map(lambda x: x.replace("\"",""), data["pages"])
data["pages"]=map(lambda x: x.split(','), data["pages"])

#check how many pages contain this: 
findthis="sportinglife.com/racing/racecards"
findthis="sportinglife.com/racing/results"
findthis="sportinglife.com"
#uniquePages=set()  #find unique pages 
for month in set(data["month"]):
    allSum=0
    pageSum=0    
    tmpData=data.loc[(data["month"]==month)]    
    for i in range(0, tmpData.shape[0]):
        for page in tmpData.iloc[i]["pages"]:
            if (page.find(findthis)>=0):
                pageSum+=1
            allSum+=1         
    print ("Month: %d. Views: %d Density: %f" % (month, pageSum, pageSum/float(allSum)))

    
#create a dataframe which sum of each page
#filter out data
#the filtering process in after sorting users by pages views below
for i in range(0, len(filterout)):
    data=data[~((data["user"]==filterout.iloc[i]["user"]) & (data["month"]==filterout.iloc[i]["month"]))]

# find the volume of each page

Data2 = pd.DataFrame(data=None, columns=['pages', 'volume'])
for site in set(data["site"]):
    pagesData=[]
    for pages in data[data["site"] == site]["pages"]:
        for p in pages:
            pagesData.append(p)

    pagesData.sort()
    recent=pagesData[0]
    newPagesData=[]
    newPagesData.append(recent)
    newCounterData=[]
    newCounterData.append(1)
    for i in range(1,len(pagesData)):
        page=pagesData[i]
        if page==recent:
            newCounterData[len(newCounterData)-1]+=1
        else:
            recent=page
            newPagesData.append(recent)
            newCounterData.append(1)
    Data2 = Data2.append(pd.DataFrame({'pages':newPagesData, 'volume':newCounterData}).sort_values(by="volume", ascending=False), ignore_index=True)

Data2.to_csv('C:\\Users\\yaakov.tayeb\\Desktop\\\pages.csv', header=True, mode='a', index=False)


plt.figure(1, figsize=(12,4))
x = data2.iloc[0:1000]["pages"]
y = data2.iloc[0:1000]["volume"]
plt.ylim(y.min()*0.9, y.max()*1.1)
plt.bar(range(1,1001), y)
data2

# Sum pages per user
Data2 = data.copy()
Data2["numpages"]=map(lambda x: len(x), Data2["pages"])
Data2_user = []
Data2_pages = []
Data2_site = []
newCounterData=[]
for site in set(data["site"]):
    for user in set(data.loc[data["site"] == site]["user"]):
        pages = sum(Data2.loc[(Data2["user"]==user) & (Data2["site"] == site)]["numpages"])
        Data2_user.append(user)
        Data2_pages.append(pages)
        Data2_site.append(site)

Data2 = pd.DataFrame({'site': df_site, 'user':df_user, 'pages':df_pages})
Data2 = Data2.sort_values(['site', 'pages'], ascending=[1, 0])


# Plotting
for site in set(Data2["site"]):
    #plt.ion()
    #plt.cla()
    plt.figure(1, figsize = (12,4))
    x = Data2.loc[(Data2["site"] == site)]["pages"]
    plt.hist(x)
    plt.xlabel('Page Views')
    plt.suptitle("Site: %s - Page Views" % site)
    plt.draw()
    plt.pause(0.001)
    raw_input("Press Enter to continue...") #stop for manual processing

site = "next.co.uk"
site = 'marketrealist.com'
plt.figure(1, figsize = (12,4))
x = Data2.loc[(Data2["site"] == site)]["pages"]
plt.hist(x)
plt.xlabel('Page Views')
plt.suptitle("Site: %s - Page Views" % site)
plt.draw()


#quantiles
df[df["month"]==3]["pages"].describe()
df[df["month"]==3]["pages"].quantile(0.75)
df[df["month"]==3]["pages"].quantile(0.80)
df[df["month"]==3]["pages"].quantile(0.85)
df[df["month"]==3]["pages"].quantile(0.95)

#start filtering
len(df)
len(df[df["pages"]>=158]["user"])


#save a csv:
#data.to_csv('/Users/yaakovtayeb/github/similar/Clients/sportinglife.com_PP_Full.tsv', header=True, mode='a')