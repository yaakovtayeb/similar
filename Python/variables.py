from random import randint
#var in sentence in Python. Go figure.
hw12 = '%s %s %d' % ("hello", "world", 12)  
print hw12

#string functions:
s = "hello"
print s.capitalize()  # Capitalize a string; prints "Hello"
print s.upper()       # Convert a string to uppercase; prints "HELLO"
print s.replace('l', '(ell)')  # Replace all instances of one substring with another;

#Lists
#methods, pop, append,
#functions len(), range()

xs = [3, 1, 2]   
xs=range(100)
print xs
print xs[4:20]
xs.append('bar')
xs[len(xs)-1]=1
print(xs.pop())
print(xs)
squares = [x ** 2 for x in xs] #making thing fast and complicated.


#sets - array without duplicates:

animals = {'cat', 'dog'}
animals.add('fish') 
print len(animals)  
animals.remove('cat')   
animals={randint(1, 100) for x in range (1,10)} #print 10 unique random numbers:
x=set([1,1,2,3,4,5,2]) # remove duplicates
set2 - set1 #unique for set2
set1 - set2 #unique for set1
set1.union(set2) #unique all
set1.intersection(set2) #set1 inner join set2

     
     
     
          
#dictionary: key fro every cell
d = {'cat': 'cute', 'dog': 'furry'}  # Create a new dictionary with some data
print d['cat']       # Get an entry from a dictionary; prints "cute"
print 'cat' in d     # Check if a dictionary has a given key; prints "True"
d['fish'] = 'wet'    # Set an entry in a dictionary
print d['fish']      # Prints "wet"
# print d['monkey']  # KeyError: 'monkey' not a key of d
print d.get('monkey', 'N/A')  # Get an element with a default; prints "N/A"
print d.get('fish', 'N/A')    # Get an element with a default; prints "wet"
del d['fish']        # Remove an element from a dictionary
print d.get('fish', 'N/A') # "fish" is no longer a key; prints "N/A"

#proper arrays - NumPy
import numpy as np
b = np.array([[1,2,3],[4,5,6]])   # Create a rank 2 array
print b.shape #print array demanions.
c = np.full((2,2), 7) # Create a constant array 2x2 full of 7s
d = np.eye(2)      # Create a 2x2 identity matrix
e = np.random.random((2,2)) # Create an array filled with random values
np.arange(4) #array[(0,1,2,3,4])
#array math:
x = np.array([[1,2],[3,4]], dtype=np.float64)
y = np.array([[5,6],[7,8]], dtype=np.float64)
print x + y #print np.add(x, y)
#multiply (*) is elementwise multiplication, not matrix multiplication
print np.multiply(x, y)            
#in order to matric multiplication:
print np.dot(x, y)    

print x, np.sum(x) #sum function:
print x.T #traspose

#data frames:
#import numpy as np (must)
import pandas as pd
import matplotlib.pyplot as plt #plotting
data = {'year': [2010, 2011, 2012, 2011, 2012, 2010, 2011, 2012],
        'team': ['Bears', 'Bears', 'Bears', 'Packers', 'Packers', 'Lions', 'Lions', 'Lions'],
        'wins': [11, 8, 10, 15, 11, 6, 10, 4],
        'losses': [5, 8, 6, 1, 5, 10, 6, 12]}
football = pd.DataFrame(data, columns=['year', 'team', 'wins', 'losses'])
from_csv = pd.read_csv('mariano-rivera.csv') #read from file:
cols=['year','team','wins','losses']
from_csv = pd.read_csv('mariano-rivera.csv', sep=',', header=None, names=cols) #read from file:    
from_clipboard = pd.read_clipboard() #read from clipboard
football = pd.read_excel('football.xlsx', 'Sheet1') #read from excel 
football.to_csv(filepath+"/github/machine.learning/"+"filename.csv") #save to csv and see files section
#subseting df:
football
football["year"]
football.iloc[[2]]
football.ix[2]            
football.ix[:,2]            
football.ix[1:2,2:4] 
football.columns.values #get df col names:
#subset with conditions:
football[(football.year == 2010) & (football.team == "Bears")]

          
           
#Classes:
    
class Greeter(object):    
    # Constructor
    def __init__(self, name):
        self.name = name  # Create an instance variable
        
    # Instance method
    def greet(self, loud=False):
        if loud:
            print 'HELLO, %s!' % self.name.upper()
        else:
            print 'Hello, %s' % self.name
        
g = Greeter('Fred')  # Construct an instance of the Greeter class
g.greet()            # Call an instance method; prints "Hello, Fred"
g.greet(loud=True)   # Call an instance method; prints "HELLO, FRED!"

       
#files:
import os
filepath=os.getcwd()  #get current folder path
filepath+"/github/machine.learning/"
