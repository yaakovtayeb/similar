#import os
#os.path.basename(os.getcwd())
import numpy as np
import matplotlib.pyplot as plt #ploting the process

# y = mx + b
# m is slope, b is y-intercept
def compute_error_for_line_given_points(b, m, points):
    totalError = 0
    for i in range(0, len(points)):
        x = points[i, 0]
        y = points[i, 1]
        totalError += (y - (m * x + b)) ** 2
    return totalError / float(len(points))

def step_gradient(b_current, m_current, points, learningRate):
    b_gradient = 0
    m_gradient = 0
    N = float(len(points))
    for i in range(0, len(points)):
        x = points[i, 0]
        y = points[i, 1]
        #this is the core of the algorithm
        #deltam=2/n * sigma(-Xi(Yi-(MXi+B)))
        #deltab=w/n * sigma(-(Yi-(MXi+B)))
        b_gradient += -(2/N) * (y - ((m_current * x) + b_current))
        m_gradient += -(2/N) * x * (y - ((m_current * x) + b_current))
    new_b = b_current - (learningRate * b_gradient)
    new_m = m_current - (learningRate * m_gradient)
    #print new_m," ",new_b
    return [new_b, new_m]

def gradient_descent_runner(points, starting_b, starting_m, learning_rate, num_iterations):
    b = starting_b
    m = starting_m
    for i in range(num_iterations):
        b, m = step_gradient(b, m, points, learning_rate)
        #draw_it(points,m,b)
        draw_err(num_iterations, points, m, b)
    return [b, m]

def draw_it(points, m, b):
    plt.cla()
    X = points[:,0]
    Y = points[:,1]
    plt.scatter(X, Y)
    plt.plot(X, X*m+b, color=(0.56, 0.35, 0.56))
    plt.show()
    
def draw_err(num_iterations, points, m, b):
    delta=sum(points[:,1]-(points[:,0]*m+b))
    print(str(num_iterations)+": "+str(delta))

def run():
    points = np.genfromtxt("gradient_descent_example.csv", delimiter=",")
    learning_rate = 0.0001
    initial_b = 0 # initial y-intercept guess
    initial_m = 0 # initial slope guess
    num_iterations = 100
    print "Starting gradient descent at b = {0}, m = {1}, error = {2}".format(initial_b, initial_m, compute_error_for_line_given_points(initial_b, initial_m, points))
    print "Running..."
    [b, m] = gradient_descent_runner(points, initial_b, initial_m, learning_rate, num_iterations)
    print "After {0} iterations b = {1}, m = {2}, error = {3}".format(num_iterations, b, m, compute_error_for_line_given_points(b, m, points))

run()