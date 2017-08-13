--Raw&Estimated visits for both mobile and desktop

--Tables: mobile.snapshot_estimated_values, analytics.snapshot_estimated_values
DROP TABLE yaakovt.rt_main;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.rt_main (site string, country int, mobile_rawvisits double, mobile_visits double, desktop_rawvisits double, desktop_visits double, YEAR int, MONTH int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.rt_main
SELECT m.site,
       m.country,
       m.raw_visits,
       m.visits,
       d.rawvisits,
       d.estimatedvisits,
       m.year,
       m.month
FROM mobile.snapshot_estimated_values AS m
INNER JOIN analytics.snapshot_estimated_values AS d ON (m.site=d.site
AND m.country=d.country
AND m.month=d.month
AND d.year=m.year)
WHERE
m.site="rt.com"
AND m.country=999
AND ((m.year=16
       AND m.month>11)
  OR (m.year=17
      AND m.month<3));

  hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.liverpoolfc;">/home/yaakov.tayeb/output/rt_main.tsv;

--NOW LET'S GO FOR THE SUB-DOMAINS (arabic.com.rt.com)

DROP TABLE yaakovt.rt_arabic;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.rt_arabic (site string, country int, mobile_rawvisits double, mobile_visits double, desktop_rawvisits double, desktop_visits double, YEAR int, MONTH int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.rt_arabic
SELECT m.site,
       m.country,
       m.raw_visits,
       m.visits,
       d.rawvisits,
       d.estimatedvisits,
       m.year,
       m.month
FROM mobile.snapshot_estimated_values AS m
INNER JOIN analytics.snapshot_estimated_values AS d ON (m.site=d.site
AND m.country=d.country
AND m.month=d.month
AND d.year=m.year)
WHERE
m.site="arabic.rt.com"
AND m.country=999
AND ((m.year=16
       AND m.month>11)
  OR (m.year=17
      AND m.month<3));

  hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.rt_arabic;">/home/yaakov.tayeb/output/rt_main.tsv;