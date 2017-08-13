desc analytics.snapshot_estimated_totals_incoming_referral;

drop table yaakovt.lush201603;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.lush201603 (
   site string, 
   site2 string,
   country int, 
   estimatedvisits int,
   month int,
   year int
   ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/traffic/lush201603/';

INSERT OVERWRITE TABLE yaakovt.lush201603
SELECT site,
       site2,
       country,
       Sum(estimatedvisits) AS visits,
       MONTH,
       YEAR
FROM analytics.snapshot_estimated_totals_incoming_referral
WHERE site LIKE "%lush.com%"
        AND site2 LIKE "%lush.com%"
        AND country=826
        AND YEAR=17
        AND MONTH=1
GROUP BY site,
         site2,
         country,
         YEAR,
         MONTH;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.lush201603;">/home/yaakov.tayeb/output/lush201603.tsv;