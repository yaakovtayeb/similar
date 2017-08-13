# Working with Linear Models the Easy Way

## Solving Overfitting Using Selection

if (!"glmnet" %in% rownames(installed.packages())) {install.packages("glmnet")}
install.packages("glmnet")

data(Boston, package="MASS")
library(glmnet)
X <- as.matrix(scale(Boston[,1:ncol(Boston)-1]))
y <- as.numeric(Boston[,ncol(Boston)])
fit = glmnet(X, y, family="gaussian", alpha=1, standardize=FALSE)
plot(fit, xvar="lambda", label=TRUE, lwd=2)

cv <- cv.glmnet(X, y, family="gaussian", alpha=1, standardize=FALSE)
coef(cv, s="lambda.min")