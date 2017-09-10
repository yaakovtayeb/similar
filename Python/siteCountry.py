import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats
import datetime
from itertools import product

def oneout(countries):
    result = list()
    for i in range(0, countries):
        str = '1'*i+'0'+'1'*(countries-i-1)
        result.append(str)
    return result


def cleanCommans(dataframe):
    for x in dataframe.columns.values:
        dataframe[x]=map(lambda x: x.replace(",","") if type(x) is str else x, dataframe[x])
    return dataframe.apply(pd.to_numeric, errors="ignore")

def removeTableName(data):
    cols = list()
    for n in data.columns.values:
        findit = n.find(".")+1
        cols.append(n[findit:len(n)])
    data.columns = cols

#download the data using the file site_country.hql

path = "C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\chitai-gorod.ru.tsv"
data = pd.read_csv(path, sep='\t', header=0) #read from file
# y = pd.read_clipboard(sep='\t', header=None) #read from clipboard
# y.columns=["y"]
data = cleanCommans(data)
removeTableName(data)
data["date"] = map(lambda y,m: datetime.date(y, m, 1).strftime('%d.%m.%Y'), data["year"]+2000, data["month"])
# data.loc[data["country"]=="GA", "country"] = "0"
data["alldata"] = data["dvisits"] + data["mvisits"]
# data.drop(data[(data["date"]=="01.08.17")].index, inplace=True)
data.head()
print(data.columns.values)

# read the GA
path = "C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\\brit.co2.txt"
y = pd.read_csv(path, sep='\t', header=None) #read from file
y = cleanCommans(y)
removeTableName(y)
y = y[(y["platform"]=="ga") & (y["device"] == "desktop")]["Visits"]
y = list(y.iloc[:])

# check all combination of countries comapre with GA (y)
y = data2[0]
y = data.loc[data["country"] == 0]["dvisits"]
y = data.loc[data["country"] == "0"]["dvisits"] # if originally it was "GA"
# y = [1024805.271, 1084259.93, 812266.34, 901666.3, 1, 322476.0]
# filter data - only real full countries
data = data[(data["country"] < 999) & (data["country"] > 0)] # remobe states

# pick countries which correlation with GA is bigger than 0.1
countries = set(data["country"])
r = list()
countrieslist=list()
for c in countries:
    x = data.loc[(data["country"] == c), "mvisits"]
    if len(x) == len(y):
        slope, intercept, r_value, p_value, std_err = stats.linregress(x.values, y.iloc[:,0].values)
    else:
        r_value = 0
    r.append(r_value)
    countrieslist.append(c)
correlation = pd.DataFrame(countrieslist, columns=["country"])
correlation["r"] = r
correlation = correlation.sort_values("r", ascending=[0])
correlation = correlation[correlation["r"] > 0.15]

# Pick countries that impact at least 10% of the data
countrieslist = list()
for c in set(data["country"]):
    all = np.sum(data["mvisits"])
    x = np.sum(data[data["country"] == c]["mvisits"])
    print "Country: %s. %f percentages" % (c, round(float(x)/all,4))
    if (float(x)/all > 0.01):
        countrieslist.append(c)
delta = pd.DataFrame(countrieslist, columns=["country"])

# add column per month with the data for each month-country
# make a pivot so the country is in columns and month in rows - table2

dtemp = data.loc[(data["country"].isin(list(correlation["country"]))) & (data["country"] != 0)] # change correlation to delta in case you want to include by size rather than r
dtemp = pd.pivot_table(dtemp, index=("date"), columns=("country"), values=("dvisits"), aggfunc=np.sum, fill_value=0)

# create all combination of countries
# len(correlation["country"])-1 All countries with good r without GA
repeat = len(correlation["country"])  # change correlation to delta in case you want to include by size rather than r
combinations = list("".join(x) for x in product('01', repeat=repeat))
# just one country off
# combinations = oneout(len(countries)-1)
dfComb = pd.DataFrame(columns=("combination", "delta", "r"))

for i in range(0, len(combinations)):
    try:
        # take combination multiple by country data for each month, take from this number the GA and divide by the GA
        delta = np.average((np.sum(np.array(map(int, list(combinations[i]))) * dtemp, axis=1) - np.array(y))/np.array(y))
        x = np.sum(np.array(map(int, list(combinations[i]))) * dtemp, axis=1)
        slope, intercept, r_value, p_value, std_err = stats.linregress(x, y)
        dfComb = dfComb.append(pd.DataFrame([[combinations[i], delta, r_value]], columns=("combination", "delta", "r")), ignore_index=True)
    except:
        pass

dfComb.sort_values(["r"], ascending=False, inplace=True)
dfComb.sort_values(["delta"], ascending=False, inplace=True)

x = np.sum(np.array(map(int, list(dfComb.iloc[1,0]))) * dtemp, axis=1)

d=pd.DataFrame([countrieslist, r])
d.to_csv('C:\\Users\\yaakov.tayeb\\Desktop\\panasonic3.csv', header=False, mode='w')


#create a new dataframe with each country as a variable and country=0 is the GA
data=pd.pivot_table(data[(data["country"].astype(int)<999)], index=("site", "date"), columns=("country"), values=("estimatedvisits"),aggfunc=np.sum, fill_value=0)
data.reset_index(inplace=True, drop=True)
data.columns = map(lambda col: str(col), data.columns.values)
#data.to_csv('C:\\Users\\yaakov.tayeb\\Desktop\\panasonic.csv', header=True, mode='w')

countries=list(data.columns.values)
countries = countries[1:len(countries)]

y=data["0"] #get the GA
data = data.drop("0", axis=1)
data = data.as_matrix()
coef = np.linalg.lstsq(data, y)[0]
d=pd.DataFrame([countries, list(coef)])
d.to_csv('C:\\Users\\yaakov.tayeb\\Desktop\\panasonic2.csv', header=False, mode='w')

#check correlation for each country individualy.
y=data.loc[data["country"]==0]["estimatedvisits"]
countries = set(data["country"])
r=list()
countrieslist=list()
for c in countries:
    x = data.loc[data["country"] == c, "estimatedvisits"]
    if len(x) == len(y):
        slope, intercept, r_value, p_value, std_err = stats.linregress(x, y)
    else:
        r_value = 0
    r.append(r_value)
    countrieslist.append(c)

d=pd.DataFrame([countrieslist, r])
d.to_csv('C:\\Users\\yaakov.tayeb\\Desktop\\panasonic3.csv', header=False, mode='w')





countries = set(data[(data["country"]<999)]["country"])
for c in countries:
    fig = plt.figure(1, figsize=(12, 4))
    fig.suptitle("Country: %d" % c)
    x = data.loc[(data["country"] == c) & (data["platform"] == "desktop")]["date"]
    y = data.loc[(data["country"]==c) & (data["platform"]=="desktop")]["estimatedvisits"]
    #plt.ylim(y.min() * 0.9, y.max() * 1.1)
    plt.ion()
    plt.clf()
    plt.plot(x, y)
    plt.draw()
    plt.pause(0.001)
    raw_input("Press Enter to continue...") #stop for manual processing





















fig = plt.figure(1, figsize=(12, 4))
fig.suptitle("Country: %d" % c)
raw_input("Press Enter to continue...")
