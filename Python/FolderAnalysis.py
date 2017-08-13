import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import plotly

path="C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\lg_folders.csv"
data = pd.read_csv(path, sep=',', header=0) #read from file
print(data.columns.values)

# Example data[(data["country"] == "india") & (data["url"] == "tvs") & (data["Metrics"] == "LG")].iloc[0,3:len(data.iloc[0,:])]
plt.figure(1, figsize=(12, 8))
for countryi in set(data["country"]):

plt.figure(figsize=(12, 8))
for countryi in set(data["country"]):
    subplotsi = 1
    # subplotsn = len(set(data[data["country"] == countryi]["url"]))
    for urli in set(data[data["country"] == countryi]["url"]):
        # x = data[(data["country"] == countryi) & (data["url"] == urli) & (data["Metrics"] == "SW")].iloc[0, 3:len(data.iloc[0, :])]
        x = data[(data["country"] == countryi) & (data["url"] == urli) & (data["Metrics"] == "SW")].drop(['country', 'url', 'Metrics'], axis=1)
        y = data[(data["country"] == countryi) & (data["url"] == urli) & (data["Metrics"] == "LG")].drop(['country', 'url', 'Metrics'], axis=1)
        r = np.corrcoef(x,y)[0,1]
        # plot
        plt.subplot(2, 3, subplotsi)
        plt.scatter(x, y, s=15)
        # plt.plot(y.values[0], y.values[0], color=[0.57, 0.46, 0.67])
        plt.xlabel('SimilarWeb')
        plt.ylabel('GoogleAnalytics')
        plt.title("Country: %s | Folder: %s | Correlation: %.2f" % (countryi, urli, r), fontname="Open Sans", fontsize=10)
        maxn = (max(max(x.values[0]), max(y.values[0]))) * 1.2
        plt.xlim(0, maxn)
        plt.ylim(0, maxn)
        subplotsi += 1
    plt.tight_layout()
    # plt.draw()
    plt.savefig("LG - %s.png" % (countryi))  # save the plot to file
    plt.pause(0.001)
    # raw_input("Press Enter to continue...")  # stop for manual processing
    plt.clf()


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
#            uniquePages=uniquePages.union([page]) #find unique pages
            if (page.find(findthis)>=0):
                pageSum+=1
            allSum+=1
    print ("Month: %d. Views: %d Density: %f" % (month, pageSum, pageSum/float(allSum)))


#create a dataframe which sum of each page
#filter out data
#the filtering process in after sorting users by pages views below
for i in range(0, len(filterout)):
    data=data[~((data["user"]==filterout.iloc[i]["user"]) & (data["month"]==filterout.iloc[i]["month"]))]

pagesData=[]
month=3
for pages in data[data["month"]==month]["pages"]:
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
data2=pd.DataFrame({'pages':newPagesData, 'volume':newCounterData})
data2["month"]=month
data2=data2.sort_values(by='volume', ascending=False)
#data2.to_csv('C:\\Users\\yaakov.tayeb\\Desktop\\\popular2.csv', header=True, mode='a')
data2[0:1000].to_csv('/Users/yaakovtayeb/Desktop/popular.csv', header=True, mode='a')

plt.figure(1, figsize=(12,4))
x = data2.iloc[0:1000]["pages"]
y = data2.iloc[0:1000]["volume"]
plt.ylim(y.min()*0.9, y.max()*1.1)
plt.bar(range(1,1001), y)


#sum pages per user
d2 = data.copy()
d2["numpages"]=map(lambda x: len(x), d2["pages"])
df_user=[]
df_pages=[]
df_month=[]
newCounterData=[]
for month in set(data["month"]):
    for user in set(data.loc[data["month"]==month]["user"]):
        pages = sum(d2.loc[(d2["user"]==user) & (d2["month"]==month)]["numpages"])
        df_user.append(user)
        df_pages.append(pages)
        df_month.append(month)
df=pd.DataFrame({'user':df_user, 'pages':df_pages, 'month': df_month})
df=df.sort(['month', 'pages'], ascending=[1, 0])
#filterout=df.loc[df["pages"]>195][["user", "month"]]

#plotting

plt.ion()
plt.clf()
plt.figure(1, figsize = (12,4))
x=df.loc[(df["month"]==4)]["pages"]
plt.hist(x)
plt.xlabel('Page Views')
plt.suptitle("sportinglife.com - Page Views")
plt.draw()
plt.pause(0.001)
raw_input("Press Enter to continue...") #stop for manual processing

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