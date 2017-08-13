desc mobile.daily_site_adjusted_estimations;

drop TABLE yaakovt.rollingstone0317;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.rollingstone0317 (
   site string,
   country int,
   raw_unique double,
   raw_pageviews double,
   year int,
   month int,
   day int
   ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/traffic/rollingstone0317/';

INSERT OVERWRITE TABLE yaakovt.rollingstone0317
SELECT site,
       country,
       raw_unique,
       raw_pageviews ,
       YEAR,
       MONTH,
       DAY
FROM mobile.daily_site_adjusted_estimations
WHERE site="rollingstone.com"
        AND country=826
        AND DAY=16
        AND MONTH=2
        AND YEAR=17;

--- 771 raw_page views...
--parquet-tools schema hdfs://mrp-nn-a01:8020/similargroup/data/mobile-analytics/daily/parquet-visits/year=17/month=02/day=16

SELECT site,
       pages,
       USER
FROM nataliea.mobile_parquet_visits
WHERE site="rollingstone.com"
        AND country=826
        AND DAY=16
        AND MONTH=2
        AND YEAR=17;
