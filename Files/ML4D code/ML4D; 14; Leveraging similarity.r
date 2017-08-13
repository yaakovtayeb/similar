# Leveraging Similarity

## Experimenting how centroids converge

# We call the libraries
library(datasets)
library(class)

# We divide our dataset into answer and features
answer <- iris[,5]
features <- iris[,1:4]
X <- princomp(features)$scores

clustering <- kmeans(x=X, centers=3, iter.max = 999, nstart = 10,
       algorithm = "Hartigan-Wong")

print (clustering$tot.withinss)
table(answer, clustering$cluster)

w <- rep(0,10)
for (h in 1:10) {
  clustering <- kmeans(x=X, centers=h, iter.max = 999, nstart = 10,
                       algorithm = "Hartigan-Wong")
  w[h] <- clustering$tot.withinss
}

plot(w, type='o')

clustering <- kmeans(x=X, centers=8, iter.max = 999, nstart = 10,
                     algorithm = "Hartigan-Wong")

table(answer, clustering$cluster)

plot(X[,c(1,2)], col = clustering$cluster)
points(clustering$centers[,c(1,2)], col = 1:8, pch = 15, cex = 1.2)

## Experimenting a flexible algorithm

# using a fixed seed for reproducibility, we determinate an out-of-sample selection
set.seed(seed=101)
out_of_sample <- sample(x=length(answer),25)

# in a loop we try values of k ranging from 1 to 15
for (h in 1:15) {
  
  in_sample_pred <- knn.cv(train=features[-out_of_sample,], cl=answer[-out_of_sample], 
                         k = h, l = 0, prob = FALSE, use.all = TRUE)
  # After getting the cross-validated predictions, we calculate the accuracy
  accuracy <- sum(answer[-out_of_sample]==in_sample_pred) / length(answer[-out_of_sample])
  # We print the result
  print (paste("for k=",h," accuracy is:",accuracy))
}

out_sample_pred <- knn(train=features[-out_of_sample,], test=features[out_of_sample,], 
                 cl=answer[-out_of_sample], k = 11, l = 0, prob = TRUE, use.all = TRUE)

print (table(answer[out_of_sample], out_sample_pred))