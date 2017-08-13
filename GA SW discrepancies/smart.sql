DROP TABLE yaakovt.smart;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.smart (site string, country int, mobile_rawvisits double, mobile_visits double, desktop_rawvisits double, desktop_visits double, YEAR int, MONTH int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.smart
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
m.site="smart.com.ph"
AND m.country=999
AND ((m.year=16
       AND m.month>1)
  OR (m.year=17
      AND m.month<3));