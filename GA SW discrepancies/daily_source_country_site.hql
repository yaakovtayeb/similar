--Daily:
set hivevar:qsite = 'disneystore.de*';
set hivevar:qcountry = 276;
set hivevar:qyearStart = 16;
set hivevar:qyearEnd = 16;
set hivevar:qMonthStart = 1;
set hivevar:qMonthEnd = 12;

DROP TABLE yaakovt.daily_source_data;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.daily_source_data (
  site string,
  country int,
  source int,
  visits double,
  YEAR int,
  MONTH int,
  day int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
  LINES TERMINATED BY '\n'
  LOCATION '/user/yaakov.tayeb/daily_source_data/';

INSERT OVERWRITE TABLE yaakovt.daily_source_data
SELECT site,
       country,
       source,
       sum(visits),
       year,
       month,
       day
FROM mobile.daily_site_metrics
WHERE site=${qsite}
AND year=16 and country=276
group by site, country, source, year, month, day;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.daily_source_data;">/home/yaakov.tayeb/output/daily_source_data_disney.tsv;
