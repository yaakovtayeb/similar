--Monthly:

set hivevar:qsite = 'housing.com*';
set hivevar:qcountry = 999;

DROP TABLE yaakovt.monthly_dis;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.monthly_dis (
  site string, 
  country int,
  platform string, 
  rawvisits double, 
  estimatedvisits double, 
  YEAR int, 
  MONTH int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/monthly_dis/';

INSERT OVERWRITE TABLE yaakovt.monthly_dis
SELECT site,
       country,
       'desktop',
       rawvisits,
       estimatedvisits,
       year,
       month
FROM analytics.snapshot_estimated_values
WHERE site=${qsite}
        AND country=${qcountry}
        AND ((YEAR=16 and month>=7) OR (year=17 and month<=3));

INSERT INTO yaakovt.monthly_dis
SELECT site,
       country,
       'mobile',
       raw_visits,
       visits,
       year,
       month
FROM mobile.snapshot_estimated_values
WHERE site=${qsite}
        AND country=${qcountry}
         AND ((YEAR=16 and month>=7) OR (year=17 and month<=3));;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthly_dis;">/home/yaakov.tayeb/output/housing_monthly_dis.tsv;
