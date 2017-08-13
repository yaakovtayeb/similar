# Starting with Simple Learners

## Growing Greedy Classification Trees

weather <- expand.grid(Outlook = c("Sunny","Overcast","Rain"), 
Temperature = c("Hot","Mild","Cool"), Humidity=c("High","Normal"), 
Wind=c("Weak","Strong"))
response <- c(1, 19, 4, 31, 16, 2, 11, 23, 35, 6, 24, 15, 18, 36)
play <- as.factor(c("No", "No", "No", "Yes", "Yes", "Yes", "Yes", 
"Yes", "Yes", "Yes", "No", "Yes", "Yes", "No"))
tennis <- data.frame(weather[response,],play)

if (!"rpart" %in% rownames(installed.packages())) {install.packages("rpart")}
library(rpart)
tennis_tree <- rpart(play ~ ., data=tennis, method="class", 
    parms=list(split="information"), control=rpart.control(minsplit=1))
		
# Printing the rules behind the decision tree
print(tennis_tree)

# Plotting the structure of the tree
if (!"rpart.plot" %in% rownames(installed.packages())) {install.packages("rpart.plot")}
library(rpart.plot)
prp(tennis_tree, type=0, extra=1, under=TRUE, compress=TRUE)

### Pruning Overgrown Trees

data(Titanic, package = "datasets")
dataset <- as.data.frame(Titanic)

library(rpart)
titanic_tree <- rpart(Survived ~ Class + Sex + Age, data=dataset, weights=Freq, 
method="class", parms=list(split="information"), control=rpart.control(minsplit=5))

# Prints a table on frequency of survival
print(aggregate(Freq ~ Survived, data = dataset, sum))

# First we print the unpruned solution
library(rpart.plot)
prp(titanic_tree, type=0, extra=1, under=TRUE, compress=TRUE)

# Pruning the tree and representing it
pruned_titanic_tree <- prune(titanic_tree, cp=0.02)
prp(pruned_titanic_tree, type=0, extra=1, under=TRUE, compress=TRUE)

## Taking a Probabilistic Turn
### Estimating response with Naïve Bayes

if (!"klaR" %in% rownames(installed.packages())) {install.packages("klaR")}
if (!"kernlab" %in% rownames(installed.packages())) {install.packages("kernlab")}
if (!"e1071" %in% rownames(installed.packages())) {install.packages("e1071")}
library(klaR)
data(spam, package = "kernlab")
print(spam[1,]) # prints an example

# set up a training sample
set.seed(1234)
train_idx <- sample(1:nrow(spam), ceiling(nrow(spam)*3/4), replace=FALSE)

# We apply NB classifier
naive <- NaiveBayes(type ~ ., data=spam[train_idx,], prior = c(0.9,0.1), fL = 0)

# predict on holdout units
if (!"caret" %in% rownames(installed.packages())) {install.packages("caret")}
library(caret)
predictions <- predict(naive, spam[-train_idx,])
confusionMatrix(predictions$class, spam[-train_idx,"type"])

