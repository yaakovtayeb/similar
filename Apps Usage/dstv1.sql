Drop table yaakovt.dstv1;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.dstv1 (
app string,
country int,
raw_devices double,
raw_users double,
raw_installs double,
raw_uninstalls   double,
raw_updates double,
raw_sessions double,
raw_usage_time double,
raw_sessions_squared double,
raw_real_sessions_squared double,
raw_usage_squared double,
raw_is_installed double,
raw_is_uninstalled double,
raw_qualifying_as_active_users double,
reach double,
active_users double,
sessions double,
usage_time double,
year int,
month int,
day int) 
ROW FORMAT DELIMITED FIELDS 
TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.dstv1
SELECT *
FROM mobile.daily_app_engagement_estimations
WHERE app="com.dstvmobile.app.adrifta.product"
  AND MONTH>=10
  AND MONTH<=11
  AND YEAR=16;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.dstv1;">/home/yaakov.tayeb/output/dstv1.tsv;


