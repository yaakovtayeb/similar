from plotly.offline import init_notebook_mode, plot
from plotly.graph_objs import *
import pandas as pd
import datetime
from time import sleep

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

# data = pd.read_clipboard(sep='\t') #read from clipboard
path = "C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\indiasapps.tsv"
data = pd.read_csv(path, sep="\t", header=0) #header is the line n or None
data.columns = [x.lower() for x in data.columns] # turn headers to lower case
data.columns = [x[x.find(".")+1:len(x)] for x in data.columns] #delete table name from column name

print(data.columns.values)

#change month names to numbers
for i in range(0, len(data["month"])):
    data.loc[i,"month"] = Month2Num(data.loc[i,"month"])

#Add Date
data["date"] = map(lambda y,m: datetime.date(y, m, 1).strftime('%d.%m.%y'), data["year"]+2000, data["month"])

data = cleanCommans(data)

print(data.columns.values)
data.head()

# data["dailyactive"] = data["users"]/data['qualified_active_users']
data2 = data.copy()
data2 = pd.pivot_table(data2, values=['usagetime', 'sessions'], index=['app','source'])
data2 = pd.DataFrame(data2.to_records())

print(data2.columns.values)

for a in set(data2["app"]):
    #x = data2[data2["app"] == a]["day"]
    x = [2]*len(data2[data2["app"]==a])
    y = data2[data2["app"] == a]["usagetime"]/60
    #sizeofsource = (data2["qualified_active_users"]/max(data2["qualified_active_users"]))*5+1
    sizes = data2[data2["app"] == a]["sessions"]
    #sizeofsource = sizeofsource.astype(int)
    trace1 = Scatter(
        x=x,
        y=y,
        name = "Source",
        mode = "markers",
        marker = dict(
            size = 5, # sizeofsource
            color='rgba(152, 0, 0, .8)'
            ),
        text = data2["source"]
    )
    plotdata = [trace1]
    # R = np.corrcoef(y_ga, y_sw2)[0,1]
    plotTitle = "Daily users by source - %s" % a
    layout = Layout(
        title=plotTitle,
        hovermode='closest',
        xaxis=dict(
            title='Days',
        ),
        yaxis=dict(
            title='Usage Time',
        )
    )
    fig = Figure(data=plotdata, layout=layout)
    plot(fig)
    sleep(1)
