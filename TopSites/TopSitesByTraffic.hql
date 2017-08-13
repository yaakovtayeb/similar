set hivevar:year = 17;
set hivevar:month = 5;
set hivevar:country = 999;

DROP TABLE yaakovt.topSitesByTraffic;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.topSitesByTraffic (
    site            string,
    rankcategory    string,
    sitecategory    string,
    traffic         double,
    month int,
    year int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/topSitesByTraffic';

INSERT OVERWRITE TABLE yaakovt.topSitesByTraffic
SELECT
    a.site,
    a.rankcategory,
    a.sitecategory,
    b.desktop_visits + b.mobile_visits as traffic,
    a.month,
    a.year
from analytics.toplists as a
INNER JOIN analytics.snapshot_overall_traffic AS b ON (a.site=b.site and a.month=b.month and a.year=b.year and a.country=b.country)
WHERE a.month=${month} and a.year=${year} and rankcategory="ALL" and a.country=${country} AND a.site like "%.tumblr.com"
ORDER by traffic limit 200000;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.topSitesByTraffic;">/home/yaakov.tayeb/output/topSitesByTraffic.tsv;
