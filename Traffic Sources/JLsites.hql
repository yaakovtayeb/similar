drop table yaakovt.JLsites;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.JLsites(
site            string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/JLsites/';