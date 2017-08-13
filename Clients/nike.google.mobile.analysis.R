#check YoY reducation in mobile for all countries filter including global

df <- read.table(file = "clipboard", sep = "\t", header=TRUE)

#delete commans
for (i in seq(1, length(df)[1])) {
  #print(i)
  df[,i]=gsub(",", "", df[,i])
  if (!is.na(as.numeric(df[1,i]))) {
    df[,i]=as.numeric(df[,i])
  }
}
colnames(df)=c("unique_v","4.16", "5.16", "6.16", "7.16", "8.16", "9.16","10.16", "11.16", "12.16", "1.17", "2.17", "3.17")
colnames(df)

attach(df)
domains=length(df$unique_v)/2
i=1
for (i in seq(1,domains)) {
  df2=melt(rbind(df[i,],df[i+8,]), id=c("unique_v"))
  
  print(
    qplot(
      data=df2, x=df2$variable, y=df2$value, 
      group=df2$unique_v,  
      geom=c("point", "smooth"),
      ylim=c(0, max(df2$value))
    )
  )
  readline(prompt="Press [enter] to continue")
}
#change level order to fit calendar:
df$Month=factor(df$Month, levels = c("January", "February", "March"))
#plot every traffic source
variants=c("Direct", "Mail", "Mail", "Referrals", "Social", "Organic", "Paid")
for (i in seq(1, length(variants))) {
  
}


