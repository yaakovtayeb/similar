Drop table yaakovt.dstv1;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.dstv1 (
app string,
year int,
month int,
day int,
sum(raw_devices double),
sum(raw_users double),
sum(raw_sessions double),
sum(raw_usage_time double),
sum(reach double),
sum(active_users double),
sum(usage_time double)) 
ROW FORMAT DELIMITED FIELDS 
TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.dstv1
SELECT app, year, month, day, raw_users, raw_sessions, raw_usage_time, active_users, usage_time
FROM mobile.daily_app_engagement_estimations
WHERE app="com.dstvmobile.app.adrifta.product"
  AND MONTH>=10
  AND MONTH<=11
  AND YEAR=16
  group by country;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.dstv1;">/home/yaakov.tayeb/output/dstv1.tsv;


