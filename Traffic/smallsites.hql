CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.smallsites (
site                      string,                                      
country                   int,                                          
desktop_users             double,                                       
desktop_visits            double,                                      
desktop_pageviews         double,                                       
mobile_users              double,                                       
mobile_visits             double,                                       
mobile_pageviews          double,                                       
year                      int,                                          
month                     int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/other/';

INSERT OVERWRITE TABLE yaakovt.smallsites
SELECT *
FROM analytics.snapshot_overall_traffic
WHERE COUNTRY=702
  AND (desktop_visits+mobile_visits)<5000
  AND MONTH=4
  AND YEAR=17;

