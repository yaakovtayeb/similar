drop table yaakovt.snapchat201703;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.snapchat201703 (
app                     string,
country                 int,
year int,
month int,
raw_devices             double,
raw_users               double,
raw_installs            double,
raw_sessions            double,
raw_usage_time          double,
raw_active_users  double,
reach                   double,
active_users            double,
sessions                double,
usage_time              double,
raw_is_installed  double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/snapchat201703';

INSERT INTO yaakovt.snapchat201703
SELECT app,
       country,
       YEAR,
       MONTH,
       AVG(raw_devices),
       AVG(raw_users),
       AVG(raw_installs),
       AVG(raw_sessions),
       AVG(raw_usage_time),
       AVG(raw_qualifying_as_active_users),
       AVG(reach),
       SUM(active_users) / SUM(reach) as active_app_users,
       AVG(sessions),
       SUM(usage_time) / SUM(active_users) AS usage_time,
       SUM(raw_is_installed)
FROM mobile.daily_app_engagement_estimations
WHERE YEAR=17
        AND app IN ("com.snapchat.android",
                    "com.netflix.mediaclient")
        AND country IN (840,
                        608,
                        360,
                        764,
                        702,
                        356,
                        392)
GROUP BY app,
         country,
         YEAR,
         MONTH;


desc mobile.daily_app_retention;

drop table yaakovt.snapchat_retention_check;
create external table if not EXISTS yaakovt.snapchat_retention_check (
   app string,
   county int,
   daysback int,
   users double,
   devices double,
   year int,
   month int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/snapchat_retention_check';

INSERT overwrite TABLE yaakovt.snapchat_retention_check
SELECT app,
       country,
       daysback,
       sum(users),
       sum(devices),
       YEAR,
       MONTH
FROM mobile.daily_app_retention
WHERE app IN ("com.snapchat.android",
              "com.netflix.mediaclient")
        AND country IN (840,
                        608,
                        360,
                        764,
                        702,
                        356,
                        392)
        AND YEAR IN (15,
                     16,
                     17)
        AND daysback<=30
        group by app, country, year, month, daysback;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.snapchat_retention_check;">/home/yaakov.tayeb/output/snapchat_retention_check.tsv;
hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.snapchat201703;">/home/yaakov.tayeb/output/snapchat201703.tsv;