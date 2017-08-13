desc analytics.daily_estimated_incoming;

drop TABLE yaakovt.ad_traffic_empireoption_com;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.ad_traffic_empireoption_com (
   site string,
   site2 string,
   ref_type int,
   paid int,
   estimatedvisits double,
   country int, 
   month int,
   day int,
   year int
   ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/traffic/ad_traffic_empireoption_com/';

INSERT OVERWRITE TABLE yaakovt.ad_traffic_empireoption_com
SELECT site,
       site2,
       getSpecialReferrerNameUDF(refid) as ref_type,
       getTopSpecialReferrerUDF(refid) as paid,
       sum(estimatedvisits) as visits, 
       country,
       MONTH,
       0,
       YEAR
FROM analytics.snapshot_estimated_totals_incoming_referral
WHERE SITE2 like "%empireoption.com%"
        AND country=999
        AND YEAR=17 AND month=1
        AND getTopSpecialReferrerUDF(refid)=4
GROUP BY site, site2, getSpecialReferrerNameUDF(refid), getTopSpecialReferrerUDF(refid), country, year, month; 

----
SELECT * FROM ds.parquet_visits
where site="makemoneyrobot.com" AND site2="empireoption.com" AND YEAR=17 and month=1;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.traffic_pinterest3_17;">/home/yaakov.tayeb/output/pinterest.tsv;