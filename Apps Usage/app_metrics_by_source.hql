drop table yaakovt.apps_usage;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.apps_usage (
app                     string,
country                 int,
year int,
quarter string,
current_installs double,
daily_active_users double,
active_app_users double,
usage_time double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/apps_usage/';

INSERT INTO yaakovt.apps_usage
SELECT app,
       840,
       YEAR,
       'Q1',
       AVG(reach) AS current_installs,
       AVG(active_users) AS daily_active_users,
       SUM(active_users) / SUM(reach) as active_app_users,
       SUM(usage_time) / SUM(active_users) AS usage_time
FROM mobile.daily_app_engagement_estimations
WHERE YEAR=15
        AND MONTH>=1 
        and MONTH<=3
        AND app IN ("com.twitter.android")
        AND country=840
group by app, year;
INSERT INTO yaakovt.apps_usage
SELECT app,
       840,
       YEAR,
       'Q2',
       AVG(reach) AS current_installs,
       AVG(active_users) AS daily_active_users,
       SUM(active_users) / SUM(reach) as active_app_users,
       SUM(usage_time) / SUM(active_users) AS usage_time
FROM mobile.daily_app_engagement_estimations
WHERE YEAR=15
        AND MONTH>=4
        and MONTH<=6
        AND app IN ("com.twitter.android")
        AND country=840
group by app, year;
INSERT INTO yaakovt.apps_usage
SELECT app,
       840,
       YEAR,
       'Q3',
       AVG(reach) AS current_installs,
       AVG(active_users) AS daily_active_users,
       SUM(active_users) / SUM(reach) as active_app_users,
       SUM(usage_time) / SUM(active_users) AS usage_time
FROM mobile.daily_app_engagement_estimations
WHERE YEAR=15
        AND MONTH>=7
        and MONTH<=9
        AND app IN ("com.twitter.android")
        AND country=840
group by app, year;    
INSERT INTO yaakovt.apps_usage
SELECT app,
       840,
       YEAR,
       'Q4',
       AVG(reach) AS current_installs,
       AVG(active_users) AS daily_active_users,
       SUM(active_users) / SUM(reach) as active_app_users,
       SUM(usage_time) / SUM(active_users) AS usage_time
FROM mobile.daily_app_engagement_estimations
WHERE YEAR=15
        AND MONTH>=10
        and MONTH<=12
        AND app IN ("com.twitter.android")
        AND country=840
group by app, year;        
INSERT INTO yaakovt.apps_usage
SELECT app,
       840,
       YEAR,
       'Q1',
       AVG(reach) AS current_installs,
       AVG(active_users) AS daily_active_users,
       SUM(active_users) / SUM(reach) as active_app_users,
       SUM(usage_time) / SUM(active_users) AS usage_time
FROM mobile.daily_app_engagement_estimations
WHERE YEAR=16
        AND MONTH>=1
        and MONTH<=3
        AND app IN ("com.twitter.android")
        AND country=840
group by app, year;        
INSERT INTO yaakovt.apps_usage
SELECT app,
       840,
       YEAR,
       'Q2',
       AVG(reach) AS current_installs,
       AVG(active_users) AS daily_active_users,
       SUM(active_users) / SUM(reach) as active_app_users,
       SUM(usage_time) / SUM(active_users) AS usage_time
FROM mobile.daily_app_engagement_estimations
WHERE YEAR=16
        AND MONTH>=4
        and MONTH<=6
        AND app IN ("com.twitter.android")
        AND country=840
group by app, year;        
INSERT INTO yaakovt.apps_usage
SELECT app,
       840,
       YEAR,
       'Q3',
       AVG(reach) AS current_installs,
       AVG(active_users) AS daily_active_users,
       SUM(active_users) / SUM(reach) as active_app_users,
       SUM(usage_time) / SUM(active_users) AS usage_time
FROM mobile.daily_app_engagement_estimations
WHERE YEAR=16
        AND MONTH>=7
        and MONTH<=9
        AND app IN ("com.twitter.android")
        AND country=840
group by app, year;
INSERT INTO yaakovt.apps_usage
SELECT app,
       840,
       YEAR,
       'Q4',
       AVG(reach) AS current_installs,
       AVG(active_users) AS daily_active_users,
       SUM(active_users) / SUM(reach) as active_app_users,
       SUM(usage_time) / SUM(active_users) AS usage_time
FROM mobile.daily_app_engagement_estimations
WHERE YEAR=16
        AND MONTH>=10
        and MONTH<=12
        AND app IN ("com.twitter.android")
        AND country=840
group by app, year;;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.apps_usage;">/home/yaakov.tayeb/output/twitter_sw_data.tsv;
