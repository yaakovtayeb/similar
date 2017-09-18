from plotly.offline import init_notebook_mode, plot
from plotly.graph_objs import *
import plotly.figure_factory as ff
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
        tmpdata = data.loc[(data['country'] == 458) & (data['date'] == '01.05.17')]
        fig = ff.create_facet_grid(
            tmpdata,
            x='ga_mobile',
            y='sw_mobile',
            facet_row='category'
        )
        plot(fig)
        time.sleep(1)
        # raw_input("Press Enter to continue...")  # stop for manual processing

Results = pd.DataFrame({'Country': country_list, 'Date': date_list, 'R': R_list, 'delta': delta_list, 'AbsDelata': AbsDelta_list, 'Accuracy_0.3': abs_error})
Results