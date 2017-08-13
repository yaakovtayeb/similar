--Daily:



DROP TABLE yaakovt.binomical;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.binomical (
  site string, 
  country int,
  platform string, 
  rawvisits double, 
  estimatedvisits double, 
  YEAR int, 
  MONTH int,
  total_raw_visits double, 
  total_est_visits double  
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/binomical_assessment/';

INSERT OVERWRITE TABLE yaakovt.binomical
SELECT a.*, b.all_raw, b.all_est From (
SELECT a.site,
       a.country,
       'desktop',
       sum(a.rawvisits),
       sum(a.estimatedvisits),
       a.year,
       a.month
FROM analytics.daily_estimated_values as a
WHERE a.site="liverpoolfc.com*"
        AND a.country=999
        AND a.YEAR=16
GROUP BY a.site, a.country, a.year, a.month) a INNER JOIN 
        (SELECT sum(b.rawvisits) AS all_raw,
                sum(b.estimatedvisits) AS all_est,
                b.month
         FROM analytics.daily_estimated_values as b
         WHERE 
         b.country=999
         AND b.YEAR=16 GROUP BY b.YEAR, b.MONTH) b ON (b.MONTH=a.month); 
INSERT INTO yaakovt.binomical
SELECT a.*, b.all_raw, b.all_est From (
SELECT a.site,
       a.country,
       'mobile',
       sum(a.raw_visits),
       sum(a.visits),
       a.year,
       a.month
FROM mobile.daily_site_ww_adjusted_estimations as a
WHERE a.site="liverpoolfc.com*"
        AND a.country=999
        AND a.YEAR=16
GROUP BY a.site, a.country, a.year, a.month) a INNER JOIN 
        (SELECT sum(b.raw_visits) AS all_raw,
                sum(b.visits) AS all_est,
                b.month
         FROM mobile.daily_site_ww_adjusted_estimations as b
         WHERE 
         b.country=999
         AND b.YEAR=16 GROUP BY b.YEAR, b.MONTH) b ON (b.MONTH=a.month); 

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.binomical;">/home/yaakov.tayeb/output/binomical.tsv;
