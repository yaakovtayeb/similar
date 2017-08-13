--Daily:

set hivevar:qsite = 'pinkshell.com*';
set hivevar:qcountry = 999;

DROP TABLE yaakovt.daily_dis;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.daily_dis (
  site string, 
  country int,
  platform string, 
  rawvisits double, 
  estimatedvisits double, 
  YEAR int, 
  MONTH int,
  day int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/daily_dis/';

INSERT OVERWRITE TABLE yaakovt.daily_dis
SELECT site,
       country,
       'desktop',
       rawvisits,
       estimatedvisits,
       year,
       month,
       day
FROM analytics.daily_estimated_values
WHERE site=${qsite}
        AND country=${qcountry}
        AND ((YEAR=16 and month>=4) OR (year=17 and month<=3));

INSERT INTO yaakovt.daily_dis
SELECT site,
       country,
       'mobile',
       raw_visits,
       visits,
       year,
       month,
       day
FROM mobile.daily_site_ww_adjusted_estimations
WHERE site=${qsite}
        AND country=${qcountry}
         AND ((YEAR=16 and month>=4) OR (year=17 and month<=4));;


hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.daily_dis;">/home/yaakov.tayeb/output/daily_dis.tsv;

------------------------------
-- WIDE FORMAT - INNER JOIN --
------------------------------

DROP TABLE yaakovt.wide_daily_dis;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.wide_daily_dis (
  site string, 
  country int,
  d_rawvisits double, 
  m_rawvisits double, 
  d_estimatedvisits double, 
  m_estimatedvisits double, 
  YEAR int, 
  MONTH int,
  day int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/wide_daily_dis/';

INSERT INTO yaakovt.wide_daily_dis
SELECT d.site,
       d.country,
       d.rawvisits,
       m.raw_visits,
       d.estimatedvisits,
       m.visits,
       d.year,
       d.month,
       d.day
FROM analytics.daily_estimated_values AS d
INNER JOIN mobile.daily_site_ww_adjusted_estimations AS m ON (d.site=m.site
                                                              AND d.country=m.country
                                                              AND d.year=m.year
                                                              AND d.month=m.month
                                                              AND d.day=m.day)
WHERE d.site=${qsite}
        AND d.country=${qcountry}
        AND d.year=16 and d.month>3; 

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.wide_daily_dis;">/home/yaakov.tayeb/output/wide_daily_dis.tsv;



