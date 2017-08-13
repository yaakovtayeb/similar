set hivevar:qsite = 'godaddy.com*';
set hivevar:qcountry = 999;

drop table yaakovt.trafficSources;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.trafficSources(
site                    string,
country                 int,
trafficSource           int,
refid                   int,
refflag                 int,
visits                  double,
estimatedvisits         double,
year                    int,
month                   int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/traffic/trafficSources/';

INSERT OVERWRITE TABLE yaakovt.trafficSources
SELECT  site,
        country,
        getTopSpecialReferrerUDF(refid),
        refid,
        refflag,
        visits,
        estimatedvisits,
        year,
        month
FROM analytics.snapshot_estimated_totals_sr
WHERE site=${qsite} AND country=${qcountry} AND year=17 and month=5;

hive -e "SELECT  site, sum(estimatedvisits) as allvisits FROM analytics.snapshot_estimated_totals_sr WHERE getTopSpecialReferrerUDF(refid)=3 and site like "%godaddy.com%" AND country=999 AND year=17 and month=5 group by site order by allvisits DESC;" > /home/yaakov.tayeb/output/godaddy_mail2.tsv;


hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.trafficSources;">/home/yaakov.tayeb/output/godaddy_mail2.tsv;
