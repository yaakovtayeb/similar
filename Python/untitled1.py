import pandas as pd
import matplotlib.pyplot as plt

path="C:\Users\yaakov.tayeb\Documents\GitHub\similar\Clients\sportinglife.com_PP.tsv"
data = pd.read_csv(path, sep='\t', header=0) #read from file
data.columns=map(lambda x: x.replace("popularpages.",""), data.columns.values)
data.columns.values
data["pages"]=map(lambda x: x.replace("[",""), data["pages"])
data["pages"]=map(lambda x: x.replace("]",""), data["pages"])
data["pages"]=map(lambda x: x.replace("\"",""), data["pages"])
data["pages"]=map(lambda x: x.split(','), data["pages"])

#check how many pages contain this: 
findthis="sportinglife.com/racing/results"
allSum=0
pageSum=0
for month in set(data["month"]):
    tmpData=data.loc[data["month"]==month]    
    for i in range(0, tmpData.shape[0]):
        for page in tmpData.iloc[i]["pages"]:
            if (page.find(findthis)>=0):
                pageSum+=1
            allSum+=1         
    print month
    print(pageSum/float(allSum))
    
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
data2[0:1000].to_csv('C:\\Users\\yaakov.tayeb\\Desktop\\\popular.csv', header=True, mode='a')

plt.figure(1, figsize=(12,4))
x = data2.iloc[0:1000]["pages"]
y = data2.iloc[0:1000]["volume"]
plt.ylim(y.min()*0.9, y.max()*1.1)
plt.bar(range(1,1001), y)
data2

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
#filterout=df.loc[df["pages"]>1000][["user", "month"]]

#plotting
plt.figure(1, figsize = (12,4))
x=df.loc[(df["month"]==4)]["pages"]
plt.hist(x)
plt.xlabel('Page Views')
plt.suptitle("sportinglife.com - Page Views")
plt.show()

#quantiles
df[df["month"]==3]["pages"].describe()
df[df["month"]==3]["pages"].quantile(0.75)
df[df["month"]==3]["pages"].quantile(0.80)
df[df["month"]==3]["pages"].quantile(0.85)
df[df["month"]==3]["pages"].quantile(0.95)



#start filtering
len(df)
len(df[df["pages"]>=158]["user"])
