--Monthly:

DROP TABLE yaakovt.binomical;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.binomical (
  site string, 
  country int, 
  mobile_rawvisits double, 
  mobile_total_raw_visits double, 
  mobile_visits double, 
  mobile_total_est_visits double, 
  desktop_rawvisits double, 
  desktop_total_raw_visits double, 
  desktop_visits double, 
  desktop_total_est_visits double, 
  YEAR int, 
  MONTH int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/binomical_assessment/liverpoolfc16/';

INSERT OVERWRITE TABLE yaakovt.binomical
SELECT d.site,
       d.country,
       m.raw_visits,
       tm.all_raw,
       m.visits,
       tm.all_est,
       d.rawvisits,
       tm.all_raw,
       d.estimatedvisits,
       tm.all_est,
       d.year,
       d.month
FROM analytics.snapshot_estimated_values AS d
FULL OUTER JOIN mobile.snapshot_estimated_values AS m ON (m.site=d.site
                                                        AND m.country=d.country
                                                        AND m.month=d.month
                                                        AND d.year=m.year)
INNER JOIN
                (SELECT YEAR,
                        MONTH,
                        sum(rawvisits) AS all_raw,
                        sum(estimatedvisits) AS all_est
                 FROM analytics.snapshot_estimated_values
                 WHERE YEAR=16
                 GROUP BY year, MONTH) tm ON (m.year=tm.year
                                        AND m.month=tm.MONTH)
WHERE d.site="liverpoolfc.com*"
        AND d.country=999
        AND d.year=16;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.binomical;">/home/yaakov.tayeb/output/binomical.tsv;
