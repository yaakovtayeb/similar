drop table yaakovt.unereat;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.unereat (
app                     string,
country                 int,
year int,
month int,
day int,
raw_devices             double,
raw_users               double,
raw_installs            double,
active_users  double,
reach                   double,
active_app_users            double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/unereat/';

INSERT overwrite TABLE yaakovt.unereat
SELECT app,
       country,
       YEAR,
       MONTH,
       DAY,
       raw_devices,
       raw_users,
       raw_installs,
       active_users,
       reach,
       (active_users/reach) AS active_app_users
FROM mobile.daily_app_engagement_estimations
WHERE YEAR=17
        AND MONTH=3
        AND DAY>=19
        AND DAY<=21
        AND app IN ("com.ubercab")
        AND country IN (840);

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.unereat;">/home/yaakov.tayeb/output/uber.tsv;
