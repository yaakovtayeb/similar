DROP TABLE yaakovt.payoneer_search_ads;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.payoneer_search_ads(site string, country bigint, referrerrefID int, keywords string, visits_estimatedValue double, YEAR int, MONTH int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.payoneer_search_ads
SELECT site,
       country,
       referrer.refID,
       keywords,
       visits.estimatedValue,
       YEAR,
       MONTH
FROM analytics.snapshot_estimated_totals_incoming_keywords
WHERE ((YEAR=16
        AND MONTH>=11)
       OR (YEAR=17
           AND MONTH=1))
  AND site="payoneer.com*"
  AND country=356
  AND referrer.refFlag=1;

set hive.cli.print.header=true; SELECT * FROM yaakovt.princess_mobile; >/home/yaakov.tayeb/output/payoneer_search_ads.tsv;
hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.payoneer_search_ads;">/home/yaakov.tayeb/output/payoneer_search_ads.tsv;