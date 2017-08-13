# Resorting to Ensembles of Learners

## Understanding the importance measures

if (!"randomForest" %in% rownames(installed.packages())) {install.packages("randomForest")}
if (!"caret" %in% rownames(installed.packages())) {install.packages("caret")}

library(caret)
library(randomForest)

# Data preparation
data(airquality, package="datasets")
dataset <- airquality[!(is.na(airquality$Ozone)),]
dataset[is.na(dataset)] <- -1

# Optimizing a tree
rf_grid <-  expand.grid(.mtry=c(2,3,5))
rf_model<-train(Ozone ~ ., data=dataset, method="rf",
                trControl=trainControl(method="cv",number=10),
                metric = "RMSE",
                ntree=500,
                importance = TRUE)
print (rf_model)

# Evaluate the importance of predictors
print (importance(rf_model$finalModel))


