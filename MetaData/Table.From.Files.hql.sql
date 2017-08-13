--Create Hive table from file:

--A. Find the files:
--B. Find the schema
--C. Create new table
--D. Update the table: msck repair <tablename>; 
--E. Check everything: desc formated <tablename>


--parquet-tools schema hdfs://mrp-nn-a01:8020/similargroup/data/mobile-analytics/demographics/demographic_distribution/age/apps_country_age/year=17/month=03/day=14

drop table yaakovt.age_app ;

CREATE EXTERNAL TABLE yaakovt.age_app (
age_18_to_24_count BIGINT,
age_18_to_24_percentage double,
age_25_to_34_count BIGINT,
age_25_to_34_percentage double,
age_35_to_44_count BIGINT, 
age_35_to_44_percentage double,
age_45_to_54_count BIGINT,
age_45_to_54_percentage double,
age_55_plus_count BIGINT,
age_55_plus_percentage double,
country BIGINT,
domain string,
source string,
total_count BIGINT
)
PARTITIONED BY (year INT, month INT, day int)
STORED AS PARQUETFILE
LOCATION '/similargroup/data/mobile-analytics/demographics/demographic_distribution/age/apps_country_age/';



DROP TABLE yaakovt.rank_app_by_age;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.rank_app_by_age (
  app string, 
  month int,
  year int,
  current_installs double,
  active_app_users double,
  active_app_users_18_24 double
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/output/Rank_apps18_24/';

INSERT OVERWRITE TABLE yaakovt.rank_app_by_age
SELECT a.*,
       b.active_app_users_18_24
FROM
        (SELECT a.app,
                a.month,
                a.year,
                AVG(a.reach) AS current_installs,
                SUM(a.active_users)/SUM(a.reach) AS active_app_users
         FROM mobile.daily_app_engagement_estimations AS a
         WHERE a.year=17
                 AND a.month=2
                 AND a.country=376
                 AND a.reach>0.05
         GROUP BY a.app,
                  a.month,
                  a.year
         ORDER BY active_app_users DESC LIMIT 100) a
LEFT JOIN
        (SELECT b.domain,
                b.month,
                b.year,
                AVG(b.age_18_to_24_percentage) AS active_app_users_18_24
         FROM yaakovt.age_app AS b
         WHERE b.country=376
                 AND b.YEAR=17
                 AND b.month=2
         GROUP BY b.domain,
                  b.month,
                  b.year) b ON (a.app=b.domain
                                AND a.month=b.month
                                AND a.year=b.year);
                  
---

select SUM(active_users) / SUM(reach) AS active_app_users from mobile.daily_app_engagement_estimations where YEAR=17 AND month=2 AND app="com.whatsapp" and country=840; 

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.rank_app_by_age;">/home/yaakov.tayeb/output/rank_app_by_age.tsv;
