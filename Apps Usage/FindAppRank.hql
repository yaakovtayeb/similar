desc mobile.app_store_ranks;
drop table yaakovt.studycom_rank_journey;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.studycom_rank_journey(category string, MODE string, country int, rank int, app string, TYPE string, YEAR int, MONTH int, DAY int, store int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';


INSERT OVERWRITE TABLE yaakovt.studycom_rank_journey
SELECT *
FROM mobile.app_store_ranks
WHERE ((YEAR=17)
       OR (YEAR=16
           AND MONTH>=9))
AND country=840 
  AND app IN ("com.study.app");


--Found only minor result.
--Check other measurements:

SELECT app, Sum(raw_users),
       Sum(active_users),
       AVG(active_users) AS daily_active_users,
       SUM(active_users) / SUM(reach) AS Active_app_users
FROM mobile.daily_app_engagement_estimations
WHERE app IN ("com.study.app")
  AND country=840
  AND YEAR=16
  AND MONTH=9
group by app, country, year, MONTH, DAY;

SELECT *
FROM mobile.daily_app_engagement_estimations
WHERE app IN ("com.study.app")
  AND country=840
  AND YEAR=16
  AND MONTH=9;


--tryouts:

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.princess_mobile;">/home/yaakov.tayeb/output/princess_mobile.tsv;