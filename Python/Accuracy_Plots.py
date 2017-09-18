from plotly.offline import init_notebook_mode, plot
from plotly.graph_objs import *
import numpy as np
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
    for c in dataframe.columns.values:
        dataframe[c] = map(lambda x: x.replace(",", "") if type(x) is str else x, dataframe[c])
    return dataframe.apply(pd.to_numeric, errors="ignore")

# data = pd.read_clipboard(sep='\t') #read from clipboard
path = "C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\LorealReport.txt"
data = pd.read_csv(path, sep="\t", header=0) #header is the line n or None
data.columns = [x.lower() for x in data.columns] # turn headers to lower case
data.columns = [x[x.find(".")+1:len(x)] for x in data.columns] #delete table name from column name

print(data.columns.values)

# Drop empty columns:
# data = data.drop(['unnamed: 7', 'unnamed: 8', 'unnamed: 9'], 1)
# Drop row by condition
# data.drop(data[(data["site"]=="spree.co.za") & (data["date"]=="01.06.17")].index, inplace=True)

# Renaming columns
# data.rename(columns={'plat':'device', 'newest': 'new_alg'}, inplace=True)
# data["site"] = "etam.com"
# data = data.groupby(['device', 'month'], as_index=False).sum()

#change month names to numbers
data["month"] = map(lambda x: Month2Num(x), data["month"])
for i in range(0, len(data["month"])):
    data.loc[i,"month"] = Month2Num(data.loc[i,"month"])

# Add Date
data["date"] = map(lambda y,m: datetime.date(y, m, 1).strftime('%d.%m.%y'), data["year"]+2000, data["month"])
data = cleanCommans(data)
data = data.sort_values(by=["year", "month"])

print(data.columns.values)

R_list = list()
delta_list = list()
AbsDelta_list = list()
sites_list = list()
device_list = list()

for sites in set(data["site"]):
    for devices in set(data["device"]):
        x = data.loc[(data['site'] == sites) & (data['device'] == devices)]["date"]
        y_ga = data.loc[(data['site'] == sites) & (data['device'] == devices)]["ga value"]
        y_sw = data.loc[(data['site'] == sites) & (data['device'] == devices)]["sw value"]
        y_sw2 = data.loc[(data['site'] == sites) & (data['device'] == devices)]["old-sw"]
        trace1 = Scatter(
            x=x,
            y=y_ga,
            mode='lines+markers',
            name="'GoogleAnalytics'",
            line=dict(
                shape='linear',
                color=('rgb(255, 150, 0)')
            )
        )
        trace2 = Scatter(
            x=x,
            y=y_sw,
            mode='lines+markers',
            name="'Similar Web'",
            line=dict(
                shape='linear',
                color=('rgb(50, 50, 100)')
            )
        )
        trace3 = Scatter(
            x=x,
            y=y_sw2,
            mode='lines+markers',
            name="'Similar Web Old'",
            line=dict(
                shape='linear',
                color=('rgb(50, 150, 100)')
            )
        )
        plotdata = [trace1, trace2, trace3]

        R_list.append(np.corrcoef(y_ga, y_sw)[0, 1])
        delta = (y_sw / y_ga) - 1
        delta_list.append(np.average(delta[delta != np.inf]))
        absdelta = abs((y_sw / y_ga) - 1)
        AbsDelta_list.append(np.average(absdelta[absdelta != np.inf]))
        sites_list.append(sites)
        device_list.append(devices)

        plotTitle = "%s - %s. R: %2f. d: %2f" % (sites, devices, R_list[-1], delta_list[-1])
        layout = Layout(
            title=plotTitle,
            xaxis=dict(
                title='Dates',
            ),
            yaxis=dict(
                title='Visits',
                range=[0, max(y_sw.append(y_ga).append(y_sw))*1.1]
            )
        )
        fig = Figure(data=plotdata, layout=layout)
        plot(fig)
        sleep(1)

Results = pd.DataFrame({'Site': sites_list, 'Device': device_list, 'R': R_list, 'delta': delta_list, 'AbsDelata': AbsDelta_list})
print(Results)

    # summary.to_csv("C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\summary.csv", sep = ",")

        # raw_input("Press Enter to continue...")  # stop for manual processing