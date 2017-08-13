import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

path="C:\Users\yaakov.tayeb\Documents\GitHub\similar\Clients\sw_india.tsv"
data = pd.read_csv(path, sep='\t', header=0) #read from clipboard
data.columns=map(lambda x: x.replace("ga_analysis.",""), data.columns.values)

for y in set(data["year"]):
    for month in set(data.loc[data["year"]==y]["month"]):
        tmp_data = data.loc[(data['month'] == month) & (data['year'] == y)]       
        xSw = tmp_data["panel_est_visits"]
        yGa = tmp_data["visitsmobile"]
        r=np.corrcoef(yGa,xSw)[0,1]
        #plot
        plt.figure(1, figsize = (8,4))
        plt.scatter(xSw, yGa, color="red", marker="x", label='SW Data', linewidth=0.5)
        plt.plot(yGa, yGa, color="gray", label='Ga-Ga', linewidth=1.0)
        plt.xlabel('SimilarWeb')
        plt.ylabel('Google')
        plt.legend(loc='upper right')
        plt.suptitle("India, SW-GA. Date:%d.%d R:%f" % (y, month, r))
        ymax=int(np.max(np.concatenate((xSw,yGa))))
        #ymax=int(np.max(np.concatenate((xSw,yGa)))/3)
        plt.ylim([0,ymax])
        plt.xlim([0,ymax])
        #plt.clf()
        plt.show()
        print("Delta: %f" % (np.mean((xSw)/yGa)))
        raw_input("Press Enter to continue...") #stop for manual processing
    
#np.mean((xSw*2.75)/yGa)
    
print(summary)
#save output file
output=pd.DataFrame(summary)
output.to_csv('C:\\Users\\yaakov.tayeb\\Desktop\\\dis_data.csv', header=True, mode='a')


else: #save the plot
                plt.savefig("output\\%s (%d) - %s.png" % (sites, y, r)) #save the plot to file
                plt.clf()
            local_summary["delta"]=(sum(y_sw)-sum(y_ga))/float(sum(y_ga))
            local_summary["corr"]=
            summary.append(dict(local_summary))
            #print details for each site, year, device
            for k,v in local_summary.iteritems():
                print "%s:\t %s" % (k, v)
            # 