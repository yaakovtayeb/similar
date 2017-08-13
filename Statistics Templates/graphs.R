#Read CSV
setwd("~/github")
df = read.csv("Princess_mobile.csv", sep=",", header = TRUE)
attach(df)
names(df)
#finding the right sources
filter=tapply(df$unique, list(source, princess_mobile.site), sum)
goodsource=NULL
celln=1;
for (i in 1:length(filter[,1])) {
  cat(rownames(filter)[i], sum(filter[i,], na.rm = TRUE), "\n")
  if (sum(filter[i,], na.rm = TRUE)>30) {
    goodsource[celln]=rownames(filter)[i]
    celln=celln+1
  }
}
for (i in 1:length(goodsource)) {
  print(qplot(data=subset(df, source==goodsource[i]), x=ndaysfrom12, y=visits, facets=~princess_mobile.site)+geom_point(color="#56B4E9"))
  plotname=paste(goodsource[i],'plot.png', sep="_")
  dev.copy(png,plotname)
  dev.off()
}  
rm(list = ls())
#write.table(mydata, "/Users/yaakovtayeb/Desktop/mydata.txt", sep="\t", row.names=FALSE)  