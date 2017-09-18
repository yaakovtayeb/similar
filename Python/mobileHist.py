import pandas as pd
from DataCleaning.format_the_table import removeTableName

def str2array(df):
    df = map(lambda x: x.replace("[", ""), df)
    df = map(lambda x: x.replace("]", ""), df)
    df = map(lambda x: x.replace("\"", ""), df)
    df = map(lambda x: x.split(','), df)
    return df

def pageProbability(searchpage, df):
    #searchpage = string, df  = dataframe cell of arrays
    import pandas as pd
    allpages = []
    for i in range(0, len(df)):
        for page in df[i]:
            allpages.append(page)
    results = 0
    for i in allpages:
        if searchpage in i:
            results+=1
    return results/float(len(allpages)), results, len(allpages)

def pagesHist(df):
    # df  = dataframe cell of arrays
    import pandas as pd
    allpages = []
    for i in range(0, len(df)):
        for page in df[i]:
            allpages.append(page)
    hist = pd.DataFrame({'views': allpages})
    hist = hist.apply(pd.value_counts)
    hist['page'] = hist.index
    return hist

def usersHist(df):
    # df  = dataframe cell of arrays
    import pandas as pd
    hist = df[['user', 'pages']]
    hist.loc[:, 'pagesn'] = map(lambda x: len(x), hist['pages'])
    hist = pd.pivot_table(hist, values='pagesn', columns=['user'], aggfunc=np.sum)
    hist = pd.DataFrame({'user': hist.index, 'pages_num': hist.values})
    hist.sort_values(by='pages_num', axis=0, ascending=False, inplace=True)
    return hist

path="C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\\thepiratebay.org.csv"
data = pd.read_csv(path, sep=',', header=0) #read from file

data.columns = ['user', 'countries', 'sites', 'ips']
data.loc[:, "sites"] = str2array(data["sites"])
data.loc[:, "countries"] = str2array(data["countries"])
data = data.drop(['ips'], 1)
print(data.columns.values)

for i in range(0, data.shape[0]):
    newsites = []
    for j in data.iloc[i]["sites"]:
        tmp = j
        tmp = tmp.replace('http://www.', '')
        tmp = tmp.replace('http://www.', '')
        tmp = tmp.replace('http://', '')
        tmp = tmp.replace('https://', '')
        tmp = tmp[0:tmp.find("/")]
        newsites.append(tmp)
    data.set_value(i, "sites", list(set(newsites)))

pagehist = pagesHist(data["sites"])

data["vpn"] = map(lambda x: len(x), data["countries"])


pagehist.to_csv('page_hist.csv', index=False)
#check how many pages contain this:
pageProbability("wap", data["pages"])



usersHist(data)

# create a dataframe which sum of each page
# filter out data
# the filtering process in after sorting users by pages views below
for i in range(0, len(filterout)):
    data=data[~((data["user"]==filterout.iloc[i]["user"]) & (data["month"]==filterout.iloc[i]["month"]))]


data2[0:1000].to_csv('/Users/yaakovtayeb/Desktop/popular.csv', header=True, mode='a')



#quantiles
df[df["month"]==3]["pages"].describe()
df[df["month"]==3]["pages"].quantile(0.75)
df[df["month"]==3]["pages"].quantile(0.80)
df[df["month"]==3]["pages"].quantile(0.85)
df[df["month"]==3]["pages"].quantile(0.95)
