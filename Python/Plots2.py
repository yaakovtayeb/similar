from plotly.offline import init_notebook_mode, plot
from plotly.graph_objs import *

init_notebook_mode()

trace1 = Scatter(
    x=['Jan',	'Feb',	'Mar',	'Apr',	'May',	'Jun',	'Jul',	'Aug',	'Sep',	'Oct',	'Nov',	'Dec'],
    y=[623615,	669761,	475937,	518022,	467873,	392474,	452570,	476702,	451275,	502012,	629560,	702840],
    mode='lines+markers',
    name="'linear'",
    line=dict(
        shape='linear'
    )
)
trace2 = Scatter(
    x=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    y=[652545,	684786,	480233,	526876,	537120,	524439,	568619,	560090,	484654,	517782,	701423,	808531],
    mode='lines+markers',
    name="'spline'",
    line=dict(
        color='rgb(112, 12, 24)',
        shape='spline'
    )
)
trace3 = Scatter(
    x=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    y=[3672175.66,	3927875.69,	3891760.02,	3693705.33,	3741874.29,	3371397.9,	3065432.11,	2810531.7,	2631953.9,	3165009.56,	3334766.83,	3566936.08],
    mode='markers',
    name="'scatter'"
)
trace4 = Scatter(
    x=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    y=[869774,	396092,	784826,	813581,	920559,	355273,	137533,	662209,	85600,	729585,	397004,	700214],
    name="'with errors'",
    error_y=dict(
        type='data',
        array=[7000, 7000, 8000, 7000, 8000, 7000, 8000, 80, 7000, 8000, 80, 80],
        visible=True
    )
)
data = [trace1, trace2, trace3, trace4]
data = [trace4]
fig = Figure(data=data)
plot(fig)