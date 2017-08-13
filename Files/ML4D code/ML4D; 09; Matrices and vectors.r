# Demystifying the Math Behind  Machine Learning

## Using Vectorization Effectively

y <- c(44, 21, 37)
print (y)
print (length(y))

X <- matrix(c(1.1, 1, 545, 1, 4.6, 0, 345, 2, 7.2, 
	1, 754, 3), nrow=3, ncol=4, byrow=TRUE)
print(X)

X <- matrix(c(1.1, 4.6, 7.2, 1, 0, 1, 545, 345, 754, 
	1, 2, 3), nrow=3, ncol=4)
print(X)

a <- matrix(c(1, 1, 1, 0), nrow=2, byrow=TRUE)
b <- matrix(c(1, 0, 0, 1), nrow=2, byrow=TRUE)
print(a-b)

a <- matrix(c(0, 1, 1, -1), nrow=2, byrow=TRUE)
print (a*2)

X <- matrix(c(4, 5, 2, 4, 3, 3), nrow=3, byrow=TRUE)
b <- c(3, -2)
print (X%*%b) 

B <- matrix(c(3, -2,-2, 5), nrow=2, byrow=TRUE)
print(X %*% B)

