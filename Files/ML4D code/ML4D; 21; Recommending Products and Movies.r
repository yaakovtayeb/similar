# Recommending Products and Movies

## Trudging through the MovieLens dataset
if (!"recommenderlab" %in% rownames(installed.packages())) {install.packages("recommenderlab")}
library("recommenderlab")
data(MovieLense)
print(MovieLense)

print(table(as.vector(as(MovieLense, "matrix"))))

summary(colCounts(MovieLense))
summary(rowCounts(MovieLense))

average_ratings <- colMeans(MovieLense)

print(average_ratings[50])
print (colCounts(MovieLense[,50]))

## Navigating through anonimous web data
data(MSWeb)
print(MSWeb)
print(table(as.vector(as(MSWeb, "matrix"))))

## Catching the Limits of rating Data
print (colnames(MovieLense[,50]))
similar_movies <- similarity(MovieLense[,50], MovieLense[,-50], method ="cosine", which = "items")
colnames(similar_movies)[which(similar_movies>0.70)]

## Seeing SVD in action
ratings_movies <- MovieLense[rowCounts(MovieLense) > 10, colCounts(MovieLense) > 50]

ratings_movies_norm <- normalize(ratings_movies, row=TRUE)
densematrix <- as(ratings_movies_norm, "matrix")
densematrix[is.na(densematrix)] <- 0

if (!"irlba" %in% rownames(installed.packages())) {install.packages("irlba")}
library("irlba")
SVD <- irlba(densematrix, nv = 50, nu = 50)

print(attributes(SVD))
print(dim(densematrix))
print(dim(SVD$u))
print(dim(SVD$v))
print(length(SVD$d))

chosen_movie <- 45
print (paste("Choosen film:", colnames(densematrix)[chosen_movie]))
answer <- as.factor(as.numeric(densematrix[,chosen_movie]!=0))
SVD <- irlba(densematrix[,-chosen_movie], nv=50, nu=50)
rotation <- data.frame(movies=colnames(densematrix[,-chosen_movie]),SVD$v)

if (!"randomForest" %in% rownames(installed.packages())) {install.packages("randomForest")}
library("randomForest")
train <- sample(1:length(answer),500)
user_matrix <- as.data.frame(SVD$u[train,])
target_matrix <- as.data.frame(SVD$u[-train,])
model <- randomForest(answer[train] ~., data=user_matrix, importance=TRUE)

response <- predict(model, newdata=target_matrix, n.trees=model$n.trees)
confusion_matrix <- table(answer[-train],response)
precision <- confusion_matrix[2,2] / sum(confusion_matrix[,2])
recall    <- confusion_matrix[2,2] / sum(confusion_matrix[2,])
print (confusion_matrix)
print(paste("Precision:",round(precision,3),"Recall:"round(recall,3)))

varImpPlot(model,n.var=10)

rotation[order(rotation[,2]),1:2]

similarity(ratings_movies[,45], ratings_movies[,145], method ="cosine", which = "items")
similarity(ratings_movies[,45], ratings_movies[,82], method ="cosine", which = "items")
