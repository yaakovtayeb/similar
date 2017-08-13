--Monthly:
set hivevar:qsite = 'disneystore.de*';
set hivevar:qyearStart = 16;
set hivevar:qyearEnd = 16;
set hivevar:qMonthStart = 1;
set hivevar:qMonthEnd = 12;

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

INSERT OVERWRITE TABLE yaakovt.monthlyCountryDis
SELECT site, country, desktop_visits, desktop_users, mobile_visits, mobile_users, year, month
FROM analytics.snapshot_overall_traffic
WHERE (site=${qsite})
        AND ((YEAR=${qyearStart} and month>=${qMonthStart}) OR (year=${qyearEnd} and month<=${qMonthEnd}));

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthlyCountryDis;">/home/yaakov.tayeb/output/disneystore.de.tsv;

