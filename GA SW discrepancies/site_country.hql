--Monthly:

DROP TABLE yaakovt.monthlyCountryDis;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.monthlyCountryDis (
site                    string,
country                 int,
dvisits                 double,
dusers                  double,
mvisits                 double,
musers                  double,
year                    int,
month                   int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/monthlyCountryDis/';

set hivevar:qsite = 'movistar.cl*';
set hivevar:qyearStart = 16;
set hivevar:qyearEnd = 17;
set hivevar:qMonthStart = 3;
set hivevar:qMonthEnd = 3;

MSCK REPAIR TABLE analytics.snapshot_overall_traffic;
INSERT OVERWRITE TABLE yaakovt.monthlyCountryDis
SELECT site, country, desktop_visits, desktop_users, mobile_visits, mobile_users, year, month
FROM analytics.snapshot_overall_traffic
WHERE (site=${qsite})
        AND ((YEAR=${qyearStart} and month>=${qMonthStart}) OR (year=${qyearEnd} and month<=${qMonthEnd})) and country<999;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthlyCountryDis;">/home/yaakov.tayeb/output/fmshoes.com.tw.tsv;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthlyCountryDis where country in (356, 682, 634, 784);">/home/yaakov.tayeb/output/squareyards.com.tsv;

