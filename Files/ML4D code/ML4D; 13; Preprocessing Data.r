# Preprocessing data

## Choosing the right replacement strategy

if (!"zoo" %in% rownames(installed.packages())) {install.packages("zoo")}
library(zoo)
df <- data.frame(A=c(1,NA,3,NA,5), B=c(2,2,NA,3,3), C=c(NA,NA,NA,8,NA)) 
print(df)

df <- subset(df, select = c('A','B'))
df['m_B'] <- as.numeric(is.na(df$B))
df$B[is.na(df$B)] <- mean(df$B, na.rm=TRUE)
df$A <- na.approx(df$A)
print(df)

## Transforming Distributions: creating a min-max normalization function

min_max <- function(x) {return ((x - min(x, na.rm=TRUE)) / (max(x, na.rm=TRUE) - min(x, na.rm=TRUE)))}
