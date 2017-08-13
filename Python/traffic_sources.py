import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import datetime

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

data = pd.read_clipboard(sep='\t') #read from clipboard
d=data.copy
data = pd.read_csv("traffic_sources_ex_data.csv", sep=",", header=0) #read data
print(data.columns.values)
print(data.columns.values.tolist() )#show col names:

#drop commas
for source in data.columns.values:
    data[source]= map(lambda x: x.replace(",","") if type(x) is str else x, data[source])
data=data.apply(pd.to_numeric, errors='ignore')
    
#Add proper date
data["date"]=np.ones(len(data.iloc[:,0]))
data["date"]=map(lambda y,m: datetime.date(y, Month2Num(m),1), data["Year"], data["Month"])

#Deal with Affiliates:
data["Paid"]+=data["Affiliates"]
data["Direct"]+=data["(Other)"]
data=data.drop(['Affiliates', '(Other)', 'Year', 'Month'], axis=1)

#adding new column:
data["device2"]=data["device"]
data.loc[data["device2"]=="tablet", ["device2"]]="mobile"

#plot SW against GA for organice and paid

X = data.loc[data["measurment"]=="GA", ["date"]]
for source in data.columns.values:
    if ((source!="date") & (source !="measurment")):
        y1=data.loc[data["measurment"]=="GA", [source]]
        y2=data.loc[data["measurment"]=="SW", [source]]
        r=np.corrcoef(y1.T,y2.T)[0,1]
        delta=np.average(np.multiply(y1,1/y2))
        plt.plot (X, y2, color='lightblue', alpha=1.00, marker='o', label="SW", linewidth=2)
        plt.plot (X, y1, color='orange', alpha=1.00, marker='o', label="GA", linewidth=2)
        plt.suptitle("%s: Correlation: (%f); Delta: (%f)" % (source, r, delta))
        plt.legend(loc="upper right")
        plt.grid(color='gray', linestyle='-', linewidth=0.05, fillstyle="full")
        plt.show()
        raw_input("Press Enter to continue...") #stop for manual processing
    


