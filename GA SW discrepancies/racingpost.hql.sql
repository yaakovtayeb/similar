--Monthly:

DROP TABLE yaakovt.discrepancies_m;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.discrepancies_m (
  site string, 
  country int,
  platform string, 
  rawvisits double, 
  estimatedvisits double, 
  rawunique double,
  estimatedunique double,
  YEAR int, 
  MONTH int 
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/discrepancies_m/';

INSERT OVERWRITE TABLE yaakovt.discrepancies_m
SELECT site, country, 'desktop', rawvisits, estimatedvisits, rawunique, estimatedunique, year, month
FROM analytics.snapshot_estimated_values
        WHERE site="racingpost.com*"
        AND country=999
        AND ((year=16 and month>9) or (year=17));
        

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.discrepancies_m;">/home/yaakov.tayeb/output/discrepancies_m.tsv;
