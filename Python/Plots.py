from plotly import tools
import plotly.plotly
from plotly.offline import download_plotlyjs, init_notebook_mode, plot
from plotly.graph_objs import *
init_notebook_mode()
import itertools
import pandas as pd
import numpy as np


path="C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\lg_folders.csv"
data = pd.read_csv(path, sep=',', header=0) #read from file
print(data.columns.values)

# what is the max url n for all countries

columns = max(list(map(lambda x: len(set(data.loc[data["country"]==x]["url"])), set(data["country"]))))
rows = len(set(data["country"]))
j = 1
ij = 1
fig = tools.make_subplots(rows=rows, cols=columns)
for countryi in set(data["country"]):
    i = 1 # pointrer for the subplot
    for urli in set(data[data["country"] == countryi]["url"]):
        x = data[(data["country"] == countryi) & (data["url"] == urli) & (data["Metrics"] == "SW")].drop(['country', 'url', 'Metrics'], axis=1)
        y = data[(data["country"] == countryi) & (data["url"] == urli) & (data["Metrics"] == "LG")].drop(['country', 'url', 'Metrics'], axis=1)
        r = np.corrcoef(x,y)[0,1]

        # plot
        trace = Scatter(
            x = x.values[0],
            y = y.values[0],
            mode='markers'
        )
        xname = 'xaxis' + str(ij)
        yname = 'yaxis' + str(ij)
        maxxy = list(itertools.chain.from_iterable([x.values[0], y.values[0]]))
        plotTitle = "%s - %s" % (urli, countryi)
        fig.append_trace(trace, j, i)
        fig['layout'][xname].update(title=plotTitle, range = [0, maxxy])
        fig['layout'][yname].update(title='', range=[0, maxxy])
        i += 1
        ij += 1
    j += 1

fig['layout'].update(title='Sites by Country', height=1000)
plot(fig)

