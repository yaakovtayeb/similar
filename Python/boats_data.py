import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
boats_data = pd.read_clipboard(sep='\t') #read from clipboard
set(boats_data["Month"])
boats_data.loc[boats_data['Month'] == 'January', 'Month'] = 1
boats_data.loc[boats_data['Month'] == 'February', 'Month'] = 2
boats_data.loc[boats_data['Month'] == 'March', 'Month'] = 3

set(boats_data)              

#x=np.linspace(min(set(tmp_data.Month)), max(set(tmp_data.Month)), 200)


x=list(set(boats_data.Month))
summary=list()
local_summary={}    
for sites in set(boats_data["site"]):
    local_summary["site"]=sites
    for y in set(boats_data["Year"]):
        local_summary["year"]=y
        for devices in set(boats_data["device"]):
            tmp_data=boats_data.loc[(boats_data['site'] == sites) & (boats_data['device'] == devices) & (boats_data['Year'] == y)]
            y_sw=tmp_data["SW value"]
            y_ga=tmp_data["GA value"]
            #plot
            plt.figure(1, figsize = (8,4))
            plt.plot(x, y_sw, 'b-', label='SW Data', linewidth=2.0)
            plt.plot(x, y_ga, 'r-', label="GA Data", linewidth=2.0)
            plt.xlabel('Month')
            plt.ylabel('Visits')
            plt.legend(loc='upper right')
            plt.suptitle("%s (%d) - %s" % (sites, y, devices))
            ymax=np.max(np.concatenate((y_ga,y_sw)))*1.5
            plt.ylim([0,ymax])
            plt.show()
            local_summary[devices+"_d"]=(sum(y_sw)-sum(y_ga))/float(sum(y_ga))
            local_summary[devices+"_r"]=np.corrcoef(y_sw,y_ga)[0,1]
            summary.append(dict(local_summary))
            #print details for each site, year, device
            for k,v in local_summary.iteritems():
                print "%s:\t %s" % (k, v)
            del local_summary[devices+"_d"]
            del local_summary[devices+"_r"]
            raw_input("Press Enter to continue...")
print(summary)
