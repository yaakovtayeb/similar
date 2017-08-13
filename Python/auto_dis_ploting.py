import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
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
show_plots=True
#change month names to numbers
for i in range(0, len(data["Month"])):
    data.loc[i,"Month"] = Month2Num(data.loc[i,"Month"])

#Add Date
data["date"] = map(lambda y,m: datetime.date(y, m, 1), data["Year"], data["Month"])

#remove commas:
data["GA value"]=data["GA value"].str.replace("\,","").astype('float')
data["SW value"]=data["SW value"].str.replace("\,","").astype('float')
data["sw-global"]=data["sw-global"].str.replace("\,","").astype('float')

#x=list(set(data.Month))
summary=list()
local_summary={}
for sites in set(data["Site"]):
    local_summary["site"] = sites
    for devices in set(data["Device"])-set(["Mobile"]):
    for devices in set(data["Device"]):
        local_summary["device"] = devices
        x = data.loc[(data['Site'] == sites) & (data['Device'] == devices)]["date"]
        y_ga = data.loc[(data['Site'] == sites) & (data['Device'] == devices)]["GA value"]
        y_sw = data.loc[(data['Site'] == sites) & (data['Device'] == devices)]["SW value"]
        y_sw2 = data.loc[(data['Site'] == sites) & (data['Device'] == devices)]["sw-global"]

        # plot
        plt.ion()
        plt.clf()
        plt.figure(1, figsize = (8,4))
        plt.plot(x, y_sw, 'b-', label='SW Data', linewidth=2.0)
        plt.plot(x, y_ga, 'r-', label="GA Data", linewidth=2.0)
        plt.plot(x, y_sw2, 'g-', label="global", linewidth=2.0)
        plt.xlabel('month')
        plt.ylabel('Visits')
        plt.legend(loc='upper right')
        plt.suptitle("%s - %s" % (sites, devices))
        ymax=int(np.max(np.concatenate((y_ga, y_sw))))
        plt.ylim([0,ymax])
        if show_plots == True: #display the plot
            plt.draw()
            plt.pause(0.001)
        else: #save the plot
            plt.savefig("output\\%s (%d) - %s.png" % (sites, y, devices)) #save the plot to file

        # save summary
        local_summary["delta"]=(sum(y_sw)-sum(y_ga))/float(sum(y_ga))
        local_summary["corr"]=np.corrcoef(y_sw,y_ga)[0,1]
        summary.append(dict(local_summary))

        # print details for each site, year, device
        for k,v in local_summary.iteritems():
            print "%s:\t %s" % (k, v)
        raw_input("Press Enter to continue...") #stop for manual processing

print(summary)
#save output file
output=pd.DataFrame(summary)
output.to_csv('C:\\Users\\yaakov.tayeb\\Desktop\\\dis_data.csv', header=True, mode='a')