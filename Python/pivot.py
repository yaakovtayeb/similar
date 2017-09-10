from plotly import tools
import plotly.plotly
from plotly.offline import download_plotlyjs, init_notebook_mode, plot
from plotly.graph_objs import *
init_notebook_mode()
import itertools
import pandas as pd
import numpy as np

init_notebook_mode()

def Month2Num(month):
    if type(month)==str:
        month=month.strip()
    cal = {}
    cal["January"]=1
    cal["january"]=1
    cal["Jan"]=1
    cal["jan"]=1
    cal["February"]=2
    cal["february"]=2
    cal["Feb"]=2
    cal["jan"]=2
    cal["March"]=3
    cal["march"]=3
    cal["Mar"]=3
    cal["jan"]=3
    cal["April"]=4
    cal["april"]=4
    cal["Apr"]=4
    cal["jan"]=4
    cal["May"]=5
    cal["may"]=5
    cal["June"]=6
    cal["june"]=6
    cal["Jun"]=6
    cal["jun"]=6
    cal["July"]=7
    cal["july"]=7
    cal["Jul"]=7
    cal["jul"]=7
    cal["August"]=8
    cal["august"]=8
    cal["Aug"]=8
    cal["aug"]=8
    cal["September"]=9
    cal["september"]=9
    cal["Sep"]=9
    cal["sep"]=9
    cal["October"]=10
    cal["october"]=10
    cal["Oct"]=10
    cal["oct"]=10
    cal["November"]=11
    cal["november"]=11
    cal["Nov"]=11
    cal["nov"]=11
    cal["December"]=12
    cal["december"]=12
    cal["Dec"]=12
    cal["dec"]=12
    if month in cal:
        return cal[month]
    else:
        return month

def cleanCommans(dataframe):
    for x in dataframe.columns.values:
    dataframe[x] = map(lambda x: x.replace(",", "") if type(x) is str else x, dataframe[x])
    return dataframe.apply(pd.to_numeric, errors="ignore")

data = pd.read_clipboard(sep='\t') #read from clipboard
path = "C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\GA_extract_Mobile_Tablet.txt"
data = pd.read_csv(path, sep="\t", header=0) #header is the line n or None
data.columns = [x.lower() for x in data.columns] # turn headers to lower case
data.columns = [x[x.find(".")+1:len(x)] for x in data.columns] #delete table name from column name

#change month names to numbers
for i in range(0, len(data["month"])):
    data.loc[i,"month"] = Month2Num(data.loc[i,"month"])

#Add Date
data["date"] = map(lambda y,m: datetime.date(y, m, 1).strftime('%d.%m.%y'), data["year"], data["month"])
data = cleanCommans(data)

print(data.columns.values)

data2=pd.pivot_table(data, index="", values=("sessions"), aggfunc=np.sum, fill_value=0)
data=pd.pivot_table(data[(data, index=("site", "date"), columns=("country"), values=("estimatedvisits"),aggfunc=np.sum, fill_value=0)


data.loc[data["ga:devicecategory"]=="tablet","ga:devicecategory"] = "mobile"
data = data.groupby(["country", "domain", "ga:month", "ga:year", "ga:devicecategory"], as_index=False)["ga:sessions"].sum()

data.to_csv('A_extract_Mobile_Tablet.tsv', sep="\t", index=False)