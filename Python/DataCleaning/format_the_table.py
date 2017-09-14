import pandas as pd

def Month2Num(month):
    # change month typos normal ones
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

def cleanCommans(dataframe):
    # remove commas from numbers and thurn these strings into real numbers
    for x in dataframe.columns.values:
        dataframe[x] = map(lambda x: x.replace(",", "") if type(x) is str else x, dataframe[x])
    return dataframe.apply(pd.to_numeric, errors="ignore")

def categoryColor(category_list):
    # return a list with a color in html formation for each category
    # no checkup for same results
    import random
    category_list = ['asdf', 'fhfg', 'asdf', 'fg']
    category_dict = {}
    for item in category_list:
        color = "#%06x" % random.randint(0, 0xFFFFFF)
        category_dict[item] = color
    results = [category_dict[item] for item in category_list]
    return results

    return result

def removeTableName(data):
    cols = list()
    for n in data.columns.values:
        findit = n.find(".")+1
        cols.append(n[findit:len(n)])
    data.columns = cols