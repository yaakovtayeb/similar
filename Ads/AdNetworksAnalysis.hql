drop table yaakovt.AdNetworkAnalysis;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.AdNetworkAnalysis(
site                    string,
country                 int,
refid                   int,
refflag                 int,
visits                  double,
estimatedvisits         double,
year                    int,
month                   int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/traffic/AdNetworkAnalysis/';

INSERT OVERWRITE TABLE yaakovt.AdNetworkAnalysis
SELECT  'All',
        country,
        refid,
        refflag,
        sum(visits),
        sum(estimatedvisits),
        year,
        month
FROM analytics.snapshot_estimated_totals_sr
WHERE refid in
    (4035, 3028024, 41, 4200, 4001, 4002, 4003, 3028145, 4122)
AND country=999 and YEAR=17 and month=5
group by country, refid, refflag, year, month;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.AdNetworkAnalysis;">/home/yaakov.tayeb/output/Toboola.tsv;
