import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


#adding data to DataFrame
s = pd.Series([1,3,5,np.nan,6,8])
dates = pd.date_range('20130101', periods=6)
df = pd.DataFrame(np.random.randn(6,4), index=dates, columns=list('ABCD'))
data = pd.read_clipboard(sep='\t') #read from clipboard
data = pd.read_csv("traffic_sources_ex_data.csv", sep=",", header=0) #header is the line n or None
df.columns.values[1] #colnames

df.describe()#Boom, describe stat
df.T #transpose
df.sort_values(by='B') #sorting by data

#Getting data
df['A']
df.loc[:,["A", "B"]] #data by column names and line numbers
df.loc[0:2,["A", "B"]]
df.loc["2013-01-02", ["A"]]
df.iloc[0] #data by position
df.iloc[:,0]
df.iloc[:]["A"]

#setting data
df["F"]=[1,2,3,4,5,6]
df.loc[:,'D'] = np.array([5] * len(df)) #using numpy
df.loc[df["A"]>1, ["B"]]=9 #assign value by condition

#basic stat:
df.mean() #average by column
df.mean(1) #average by row

#apply
df.apply(lambda x: x.max() - x.min())
df["A"]=df["A"]-1

s = pd.Series(np.random.randint(0, 10, size=5))
s.value_counts()

#add two dataframes together (must have the same columns)
result = pd.concat([df1, df2])

#Add a row
s = pd.DataFrame(np.random.randn(1, 5), columns=['A','B','C','D','F'])
df=array()
df.append(s, ignore_index=True)

#add a clo


#remove a column:
s = pd.DataFrame(np.random.randn(1, 5))
df=np.array([])
df=s.append(s, ignore_index=True)
df = df.drop([0,1,2], 1)

#remove a columnn by name
df.columns=["a","b","c","d","e"]
df = df.drop(["a","c"],1)

#Grouping or Aggregating:
df = pd.DataFrame({'A' : ['foo', 'bar', 'foo', 'bar',
'foo', 'bar', 'foo', 'foo'],
'B' : ['one', 'one', 'two', 'three',
'two', 'two', 'one', 'three'],
'C' : np.random.randn(8),
'D' : np.random.randn(8)})
df.groupby('A').sum()
df.groupby(['A','B']).sum()

#pivot table
pd.pivot_table(df, values='D', index=['B'], columns=['A']) #values are an AVG


