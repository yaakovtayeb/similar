--Monthly:

DROP TABLE yaakovt.binomical;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.binomical (
  site string, 
  country int,
  platform string, 
  rawvisits double, 
  total_raw_visits double, 
  estimatedvisits double, 
  total_est_visits double, 
  YEAR int, 
  MONTH int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/binomical_assessment/';

INSERT OVERWRITE TABLE yaakovt.binomical
SELECT d.site,
       d.country,
       'desktop',
       d.rawvisits,
       td.all_raw,
       d.estimatedvisits, 
       td.all_est,
       d.year,
       d.month
FROM analytics.snapshot_estimated_values AS d
INNER JOIN
                (SELECT YEAR,
                        MONTH,
                        sum(rawvisits) AS all_raw,
                        sum(estimatedvisits) AS all_est
                 FROM analytics.snapshot_estimated_values
                 WHERE YEAR=16
                 GROUP BY year, MONTH) td ON (d.year=td.year AND d.month=td.MONTH)
        WHERE d.site="liverpoolfc.com*"
        AND d.country=999
        AND d.year=16;
INSERT INTO yaakovt.binomical
SELECT m.site,
       m.country,
       'mobile',
       m.raw_visits,
       tm.all_raw,
       m.visits, 
       tm.all_est,
       m.year,
       m.month
FROM mobile.snapshot_estimated_values AS m
INNER JOIN
                (SELECT YEAR,
                        MONTH,
                        sum(raw_visits) AS all_raw,
                        sum(visits) AS all_est
                 FROM mobile.snapshot_estimated_values
                 WHERE YEAR=16
                 GROUP BY year, MONTH) tm ON (m.year=tm.year AND m.month=tm.MONTH)
        WHERE m.site="liverpoolfc.com*"
        AND m.country=999
        AND m.year=16;
;


hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.binomical;">/home/yaakov.tayeb/output/binomical.tsv;
