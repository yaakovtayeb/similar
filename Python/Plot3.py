# Few Plots on the same Axies File

from plotly.offline import init_notebook_mode, plot
from plotly.graph_objs import *
import itertools
import numpy as np
import pandas as pd

init_notebook_mode()
path="C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\lg_folders.csv"
data = pd.read_csv(path, sep='\t', header=0) #read from file
print(data.columns.values)

for countryi in set(data["country"]):
    for urli in set(data[data["country"] == countryi]["url"]):
        x = data[(data["country"] == countryi) & (data["url"] == urli) & (data["Metrics"] == "SW")].drop(['country', 'url', 'Metrics'], axis=1)
        y = data[(data["country"] == countryi) & (data["url"] == urli) & (data["Metrics"] == "LG")].drop(['country', 'url', 'Metrics'], axis=1)
        r = np.corrcoef(x,y)[0,1]

        # plot
        trace = Scatter(
            x = x.values[0],
            y = y.values[0],
            mode='markers',
            name = 'SimilarWeb'
        )

        trace2 = Scatter(
            x = y.values[0],
            y = y.values[0],
            mode = 'lines',
            name = 'GoogleAnalytics'
        )
        d = [trace, trace2]
        maxxy = max(list(itertools.chain.from_iterable([x.values[0], y.values[0]])))
        layout = dict(title='Comparing SimilarWeb and GoogleAnalytics',
                      xaxis=dict(title='SW', range=[0, maxxy]),
                      yaxis=dict(title='GA', range=[0, maxxy]),
                      )
        fig = Figure(data=d, layout=layout)
        plot(fig)
        raw_input("Press Enter to continue...")  # stop for manual processing
