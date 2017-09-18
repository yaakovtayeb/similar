SET mapred.job.queue.name = root.research_shared;

--Daily:
set hivevar:qsite = 'business.panasonic.com';
set hivevar:qcountry = 999;
set hivevar:qyearStart = 15;
set hivevar:qyearEnd = 15;
set hivevar:qMonthStart = 7;
set hivevar:qMonthEnd = 8;

DROP TABLE yaakovt.monthly_data;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.monthly_data (
  site string, 
  country int,
  platform string, 
  rawvisits double, 
  estimatedvisits double, 
  YEAR int, 
  MONTH int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
  LINES TERMINATED BY '\n' 
  LOCATION '/user/yaakov.tayeb/monthly_data/';

--Desktop
INSERT OVERWRITE TABLE yaakovt.monthly_data
SELECT site,
       country,
       'desktop',
       rawvisits,
       estimatedvisits,
       year,
       month
FROM analytics.snapshot_estimated_values
WHERE site IN ('mymalls.com*')
and year=17 and month>=6;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthly_data;">/home/yaakov.tayeb/output/viocom.tsv;

INSERT INTO yaakovt.monthly_data
INSERT OVERWRITE TABLE yaakovt.monthly_data
SELECT  site,
        country,
        'mobile',
        raw_visits,
        visits,
        year,
        month
FROM mobile.snapshot_estimated_values
WHERE site IN ('google.com*', 'youtube.com*', 'amazon.com*', 'facebook.com*') and country = ${qcountry}
AND ((YEAR=${qyearStart} and month>=${qMonthStart}) OR (year=${qyearEnd} and month<=${qMonthEnd}));

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthly_data;">/home/yaakov.tayeb/output/totaljobs6.tsv;
