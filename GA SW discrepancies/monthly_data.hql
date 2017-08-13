--Daily:
set hivevar:qsite = 'business.panasonic.com';
set hivevar:qcountry = 999;
set hivevar:qyearStart = 16;
set hivevar:qyearEnd = 17;
set hivevar:qMonthStart = 3;
set hivevar:qMonthEnd = 4;

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
WHERE site=${qsite}
AND ((YEAR=${qyearStart} and month>=${qMonthStart}) OR (year=${qyearEnd} and month<=${qMonthEnd}));

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthly_data;">/home/yaakov.tayeb/output/viocom.tsv;

INSERT OVERWRITE TABLE yaakovt.monthly_data
--INSERT INTO yaakovt.monthly_data
SELECT site,
       country,
       'mobile',
       sum(raw_visits),
       sum(visits),
       YEAR,
       MONTH
FROM mobile.daily_site_ww_adjusted_estimations
WHERE country=999
  AND site IN ('oneindia.com*',
               'english.oneindia.com#',
               'hindi.oneindia.com#',
               'tamil.oneindia.com#',
               'telugu..oneindia.com#',
               'malayalam.oneindia.com#',
               'kannada.oneindia.com#',
               'bengali.oneindia.com#',
               'gujarati.oneindia.com#')
  AND ((YEAR=16
        AND MONTH>=4)
       OR (YEAR=17
           AND MONTH<=3));

;

MSCK REPAIR TABLE meta_ls_main.snapshot_estimated_values;
INSERT OVERWRITE TABLE yaakovt.monthly_data
-- INSERT INTO yaakovt.monthly_data
SELECT site,
       country,
       'mobile',
       raw_visits,
       visits,
       YEAR,
       MONTH
FROM meta_ls_main.snapshot_estimated_values
WHERE site in ('mtv.com*', 'cc.com*', 'tvland.com*')
  AND ((YEAR=17 and month<4) or (year=16 and month>2))
  and country=840;



hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthly_data;">/home/yaakov.tayeb/output/data.tsv;


select month, sum(visits)
from meta_ls_main.snapshot_estimated_values
where country=276 and year=17
and (month=10 or month=11 or month=12) group by month;