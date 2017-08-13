--Find a Page
set hivevar:qsite = '%salesforce.com%';
set hivevar:qsite2 = '%cargurus.com%';
set hivevar:qcountry = 840;

drop table yaakovt.traffic_sources;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.traffic_sources (
site                    string,
site2                   string,
source_type             int,
raw_visits              double,
year                    int,
month                   int,
day                     int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/traffic/traffic_sources/';

--INSERT INTO yaakovt.traffic_sources
INSERT OVERWRITE TABLE yaakovt.traffic_sources
SELECT site,
       "all",
        getTopSpecialReferrerUDF(specialref) as source_type,
        COUNT(site) as raw_visits,
        YEAR,
        MONTH,
        DAY
FROM ds.parquet_visits
WHERE site="cloud.google.com#"
        AND YEAR=17
        AND MONTH=3;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.find_in_visits;">/home/yaakov.tayeb/output/sales_force1_find_in_visits.tsv;
        
--Click Stream

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.clickstream_sample (
   ts string, 
   user_id string, 
   country int, 
   http_referer string, 
   previous_site string, 
   requested_site string, 
   client_redirect string, 
   server_redirect string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/clickstream_sample/';

INSERT overwrite TABLE yaakovt.clickstream_sample
SELECT ts,
       user_id,
       country_id,
       http_referer,
       previous_site ,
       requested_site,
       client_redirect,
       server_redirect
FROM desktop_panel.desktop_raw_stats
WHERE YEAR=17
        AND MONTH=3
        AND DAY=22
        AND country_id in (124, 826, 36, 710, 36)
        AND user_id IN ('cucZJuDBcdaHqU0','vvlbLAhzPzB3ypS','uXYCWCB3ghpGX0U','04bi4be7gkogrbd7g9o5188je6q','00g9l5iol5cprb8mja40818frai')
ORDER BY user_id,
         ts;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.clickstream_sample;">/home/yaakov.tayeb/output/netflix_clickstream_sample.tsv;


SELECT *
FROM desktop_panel.desktop_raw_stats
WHERE YEAR=17
        AND MONTH=2
        AND DAY=22
        AND country_id=233
        AND user_id IN ('CkPeMFEiKvVDHWr')
ORDER BY user_id,
         ts;;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.find_in_visits (
site                    string,
country                 int,
source                  int,
site2                   string,
landingpage             string,
sendingpage             string,
user                    string,
pages                   array<string>,
year                    int,
month                   int,
day                     int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/traffic/find_in_visits/';

--INSERT OVERWRITE TABLE yaakovt.find_in_visits
INSERT INTO yaakovt.find_in_visits
SELECT site,
       country,
       source,
       site2,
       landingpage,
       sendingpage,
       USER,
       pages,
       YEAR,
       MONTH,
       DAY
FROM ds.parquet_visits
WHERE site like ${qsite}
        AND site2 like ${qsite2}
        AND country=${qcountry}
        AND YEAR=17
        AND MONTH=3;


hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.find_in_visits;">/home/yaakov.tayeb/output/sales_force1_find_in_visits.tsv;
        
--Click Stream

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.clickstream_sample (
   ts string, 
   user_id string, 
   country int, 
   http_referer string, 
   previous_site string, 
   requested_site string, 
   client_redirect string, 
   server_redirect string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/clickstream_sample/';

INSERT overwrite TABLE yaakovt.clickstream_sample
SELECT ts,
       user_id,
       country_id,
       http_referer,
       previous_site ,
       requested_site,
       client_redirect,
       server_redirect
FROM desktop_panel.desktop_raw_stats
WHERE YEAR=17
        AND MONTH=3
        AND DAY=22
        AND country_id in (124, 826, 36, 710, 36)
        AND user_id IN ('cucZJuDBcdaHqU0','vvlbLAhzPzB3ypS','uXYCWCB3ghpGX0U','04bi4be7gkogrbd7g9o5188je6q','00g9l5iol5cprb8mja40818frai')
ORDER BY user_id,
         ts;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.clickstream_sample;">/home/yaakov.tayeb/output/netflix_clickstream_sample.tsv;


SELECT *
FROM desktop_panel.desktop_raw_stats
WHERE YEAR=17
        AND MONTH=2
        AND DAY=22
        AND country_id=233
        AND user_id IN ('CkPeMFEiKvVDHWr')
ORDER BY user_id,
         ts;