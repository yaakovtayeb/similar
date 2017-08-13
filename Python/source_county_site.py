import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import datetime

def cleanCommans(dataframe):
    for x in dataframe.columns.values:
        dataframe[x]=map(lambda x: x.replace(",","") if type(x) is str else x, dataframe[x])
    return dataframe.apply(pd.to_numeric, errors="ignore")

data = pd.read_csv("C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\swissquote.com.txt", sep="\t", header=0) #read data
data = cleanCommans(data)
# add date in one column
data["date"]=np.ones(len(data.iloc[:,0]))
data["date"]=map(lambda y,m: datetime.date(y, m, 1), data["year"]+2000, data["month"])
# aggregate by source, omit country
data = pd.pivot_table(data, index=["site", "source", "date"], values=["visits"], aggfunc=np.sum, fill_value=0)
data.reset_index(inplace=True)
data = data[data["site"] == "en.swissquote.com"]

plt.ion()
for site in set(data["site"]):    
    for source in set(data["source"]):
        X = data.loc[(data["source"]==source)]["date"]
        Y = data.loc[(data["source"]==source)]["visits"]
        plt.cla()
        plt.scatter([1 2 3], Y, color=[0.5,1,1], linewidth=2.0)
        plt.ylabel = "Raw Visits" 
        plt.xlabel = "Date"
        plt.title = "Source: %d" % source
        plt.show()
        plt.pause(0.05)

plt.close('all')
fig, ax = plt.subplots()
plotOneSource(ax, [1,2,3,4,5],[1,2,3,4,5], [0.5,1,1], 'one')


print(data.columns.values)
print(data.columns.values.tolist() )#show col names:

