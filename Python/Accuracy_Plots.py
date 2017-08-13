from plotly.offline import init_notebook_mode, plot
from plotly.graph_objs import *
import numpy as np
import pandas as pd
import datetime

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
path = "C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\denmark.market.gasw.tsv"
data = pd.read_csv(path, sep="\t", header=0) #header is the line n or None
data.columns = [x.lower() for x in data.columns] # turn headers to lower case
data.columns = [x[x.find(".")+1:len(x)] for x in data.columns] #delete table name from column name

print(data.columns.values)

#change month names to numbers
for i in range(0, len(data["month"])):
    data.loc[i,"month"] = Month2Num(data.loc[i,"month"])

#Add Date
data["date"] = map(lambda y,m: datetime.date(y, m, 1).strftime('%d.%m.%y'), data["year"], data["month"])

data = cleanCommans(data)

print(data.columns.values)
data.head()

summary=list()
local_summary={}
for sites in set(data["site"]):
    local_summary["site"] = sites
    for devices in set(data["device"]):
        local_summary["device"] = devices
        x = data.loc[(data['site'] == sites) & (data['device'] == devices)]["date"]
        y_ga = data.loc[(data['site'] == sites) & (data['device'] == devices)]["omni value"]
        y_sw = data.loc[(data['site'] == sites) & (data['device'] == devices)]["sw value"]
        y_sw2 = data.loc[(data['site'] == sites) & (data['device'] == devices)]["sw-new"]
        trace1 = Scatter(
            x=x,
            y=y_ga,
            mode='lines+markers',
            name="'GoogleAnalytics'",
            line=dict(
                shape='linear'
            )
        )
        trace2 = Scatter(
            x=x,
            y=y_sw,
            mode='lines+markers',
            name="'SimilarWeb'",
            line=dict(
                shape='linear'
            )
        )
        trace3 = Scatter(
            x=x,
            y=y_sw2,
            mode='lines+markers',
            name="'NewMobileAlgorithm'",
            line=dict(
                shape='linear'
            )
        )
        plotdata = [trace1, trace2, trace3]
        R = np.corrcoef(y_ga, y_sw2)[0,1]
        plotTitle = "%s - %s. R: %2f. d: %2f" % (sites, devices, R, np.average(y_sw/y_ga))
        layout = Layout(
            title=plotTitle,
            xaxis=dict(
                title='Dates',
            ),
            yaxis=dict(
                title='Visits',
            )
        )
        fig = Figure(data=plotdata, layout=layout)
        plot(fig)
        raw_input("Press Enter to continue...")  # stop for manual processing

# When the different devices are on the columns:

for sites in set(data["site"]):
    y1 = ['sw.desktop', 'sw.mobile', 'sw']
    y2 = ['ga.desktop', 'ga.mobile', 'ga']
    x = data.loc[(data['site'] == sites)]["date"]
    for i in range(0, 3):
        y_ga = data.loc[(data['site'] == sites)][y2[i]].values
        y_sw = data.loc[(data['site'] == sites)][y1[i]].values
        trace1 = Scatter(
            x=x,
            y=y_ga,
            mode='lines+markers',
            name="'GoogleAnalytics'",
            line=dict(
                shape='linear'
            )
        )
        trace2 = Scatter(
            x=x,
            y=y_sw,
            mode='lines+markers',
            name="'SimilarWeb'",
            line=dict(
                shape='linear'
            )
        )
        plotdata = [trace1, trace2]
        R = np.corrcoef(y_ga, y_sw)[0, 1]
        device = "Desktop"
        if i == 1:
            device = "Mobile"
        elif i ==2:
            device = "All"
        plotTitle = "Site - %s. %s, R: %2f" % (sites, device, R)
        layout = Layout(
            title=plotTitle,
            xaxis=dict(
                title='Dates',
            ),
            yaxis=dict(
                title='Visits',
            )
        )
        fig = Figure(data=plotdata, layout=layout)
        plot(fig)
        raw_input("Press Enter to continue...")  # stop for manual processing

