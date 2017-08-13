library(ggplot2)
library(reshape2)
#Read CSV
setwd("~/desktop")
x <- read.table(file = "clipboard", sep = "t", header=TRUE)
df = read.csv("one_india.csv", sep=",", header = TRUE)
attach(df)
detach(df)
names(df)

#omit ","
for (i in seq(1,18)) {
  df[,i]=as.numeric(gsub(",", "", df[,i]))  
}

result=lm(formula=df$All~df$SW.All, data=df)
summary(result)
coef(lm(All ~ SW.All, data = df))

df[,19]=as.Date("1.1.2000", "%d.%m.%Y")
colnames(df)[19]="Date"

#Add dates
startDatem=4
startDatey=2016
for (i in seq(1,12)) {
  celldate=as.Date(paste("1.", startDatem, ".", startDatey, sep=""), "%d.%m.%Y")
  startDatem=startDatem+1
  if (startDatem>12) {
    startDatey=startDatey+1
    startDatem=1
  }
  df[i,19]=celldate
}
i=1
#plot GA vs.SW
for (i in seq(1,9)) {
  #show correlction and regression between SW and GA.
  print(qplot(data=df, x=df[,i], y=df[,i+9], geom="point", main = paste(colnames(df)[i],round(cor(df[,i],df[,i+9]),2)))+labs(x="SimilarWeb", y="Direct"))
  readline(prompt="Press [enter] to continue")  
  #Melt the data to be presented in a 2nd plot for trend analysis
  df2=data.frame(df[,19],df[,i],df[,i+9])
  colnames(df2)=c(colnames(df)[19],colnames(df)[i],colnames(df)[i+9])
  df2=melt(df2, id="Date")
  #save the plot to the HDD
  fname=paste(colnames(df)[i], ".png")
  png(filename=fname)
  print(qplot(data=df2, x=df2$Date, y=df2$value, geom="smooth", color=df2$variable, main = paste(colnames(df)[i],round(cor(df[,i],df[,i+9]),2)))+labs(x="Date", y="UV", color="Measurment"))
  dev.off()
  #readline(prompt="Press [enter] to continue")  
}

#write.table(df, "/Users/yaakovtayeb/Desktop/mydata.txt", sep="\t", row.names=FALSE)  
