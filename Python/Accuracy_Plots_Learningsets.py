from plotly.offline import init_notebook_mode, plot
from plotly.graph_objs import *
import numpy as np
import pandas as pd
import datetime
import time
from DataCleaning.format_the_table import cleanCommans
from DataCleaning.format_the_table import Month2Num
from DataCleaning.format_the_table import categoryColor

init_notebook_mode()

# data = pd.read_clipboard(sep='\t') #read from clipboard
path = "C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\ga_sw0517.tsv"
data = pd.read_csv(path, sep="\t", header=0) # header is the line n or None
data.columns = [x.lower() for x in data.columns] # turn headers to lower case
data.columns = [x[x.find(".")+1:len(x)] for x in data.columns] # delete table name from column name

#change month names to numbers
data["month"] = map(lambda x: Month2Num(x), data["month"])

#Add Date
data["date"] = map(lambda y,m: datetime.date(y, m, 1).strftime('%d.%m.%y'), data["year"]+2000, data["month"])

data = cleanCommans(data)

# take only the top level category
data["category"] = map(lambda x: x.split('/')[0] if type(x) == str else 'None', data["category"])

print(data.columns.values)

# Remove unused columns for convenience
# data = data.drop(['pageviewmobile', 'pageviewonline', 'uniqmobile', 'uniqonline'], 1)

R_list = list()
delta_list = list()
AbsDelta_list = list()
abs_error = list()
country_list = list()
date_list = list()
sitesizeforerror = 200000
err_margin = 0.3

# Filter data
# data = data[data["visitsonline"]>800000]
# data = data[data["category"]=="Internet_and_Telecom"]

for country in [458]:
    for date in set(data["date"]):
        # for device in devices:
        err = data.loc[(data['country'] == country) & (data['date'] == date) & (data['ga_mobile'] > sitesizeforerror)][['ga_mobile', 'sw_mobile']].values
        x = data.loc[(data['country'] == country) & (data['date'] == date)]["ga_mobile"] # GA data for a specific month
        y = data.loc[(data['country'] == country) & (data['date'] == date)]["sw_mobile"] # SW
        sites_text = data.loc[(data['country'] == country) & (data['date'] == date)]["site"].values
        categories = data.loc[(data['country'] == country) & (data['date'] == date)]["category"].values
        setcolors = list(set(categories))
        colors = map(lambda x: categoryColor(x, setcolors), categories)
        dots = (np.array(y)/100000 + 1).astype(int)
        f = np.poly1d(np.polyfit(x, y, 1))
        trace1 = Scatter(
            x=x,
            y=y,
            mode='markers',
            name='Visits',
            marker = dict(
                color = colors,
                size = 7
            ),
            text=sites_text+'<BR>'+categories
        )
        trace2 = Scatter(
            x=x,
            y=f(x),
            mode='lines',
            name='SimilarWeb Correlation Line',
            line=dict(
                shape='linear',
                color='rgb(230, 150, 15)'
            )
        )
        trace3 = Scatter(
            x=x,
            y=x,
            mode='lines',
            name='GA 2 GA',
            line=dict(
                shape='linear',
                color='rgb(150, 150, 150)'
            )
        )
        plotdata = [trace1, trace2, trace3]

        R_list.append(np.corrcoef(y, x)[0,1])
        delta = (y / x) - 1
        delta_list.append(np.average(delta[(delta != np.inf) & (1-delta.isnull())]))
        absdelta = abs((y / x) - 1)
        AbsDelta_list.append(np.average(absdelta[(absdelta!=np.inf) & (1-absdelta.isnull())]))
        abs_err = abs(err[:, 0] / err[:, 1] - 1)
        # need to add remove inf and nan from abs_err
        abs_error.append(len(abs_err[abs_err > err_margin]) / float(len(abs_err)))
        country_list.append(country)
        date_list.append(date)

        plotTitle = "US Mobile Accuracy Check. Month: %s. R: %2f, d: %.2f" % (date, R_list[-1], delta_list[-1])
        layout = Layout(
            title=plotTitle,
            xaxis=dict(
                title='GoogleAnalytics',
            ),
            yaxis=dict(
                title='SimilarWeb',
            )
        )
        fig = Figure(data=plotdata, layout=layout)
        plot(fig)
        time.sleep(1)
        # raw_input("Press Enter to continue...")  # stop for manual processing

Results = pd.DataFrame({'Country': country_list, 'Date': date_list, 'R': R_list, 'delta': delta_list, 'AbsDelata': AbsDelta_list, 'Accuracy_0.3': abs_error})
Results