desc analytics.snapshot_estimated_totals_outgoing;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.outgoing_ads (
site                    string,
country                 int,
refid                   int,
refflag                 int,
site2                   string,
visits                  double,
estimatedvisits         double,
pageviews               double,
estimatedpageviews      double,
onepagevisits           double,
timeonsite              double,
type                    string,
year                    int,
month                   int) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/outgoing_ads/';

INSERT OVERWRITE TABLE yaakovt.outgoing_ads
SELECT *
FROM analytics.snapshot_estimated_totals_outgoing
WHERE SITE="lakersnation.com"
        AND refflag=1
        AND getTopSpecialReferrerUDF(refid)=4
        AND YEAR=17
        AND MONTH=4
        AND country=999;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.outgoing_ads;">/home/yaakov.tayeb/output/outgoing_ads.tsv;