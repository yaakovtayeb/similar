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
    hist = pd.DataFrame({'page': allpages})
    hist = hist.apply(pd.value_counts)
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

path="C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\movistar.com.tsv"
data = pd.read_csv(path, sep='\t', header=0) #read from file

removeTableName(data)
data.loc[:, "pages"] = str2array(data["pages"])

print(data.columns.values)

#check how many pages contain this:
pageProbability("wap", data["pages"])

pagesHist(data["pages"])

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
