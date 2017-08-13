--Monthly:
set hivevar:qsite = '%ringgitplus.com';
set hivevar:qcountry = 999;
set hivevar:qyearStart = 17;
set hivevar:qyearEnd = 17;
set hivevar:qMonthStart = 4;
set hivevar:qMonthEnd = 6;

DROP TABLE yaakovt.monthlySourceCountryDis;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.monthlySourceCountryDis (
site                    string,
country                 int,
source                  string,
visits                  bigint,
monthly_uniques         bigint,
sum_dau                 bigint,
year                    int,
month                   int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/monthlySourceCountryDis/';

INSERT OVERWRITE TABLE yaakovt.monthlySourceCountryDis
SELECT *
FROM analytics.monthly_site_country_source
WHERE site like ${qsite} and (country=999 or country=458)
        AND ((YEAR=${qyearStart} and month>=${qMonthStart}) OR (year=${qyearEnd} and month<=${qMonthEnd}));

INSERT OVERWRITE TABLE yaakovt.monthlySourceCountryDis
SELECT *
FROM analytics.monthly_site_country_source
WHERE (site like ${qsite})
        AND ((YEAR=${qyearStart} and month>=${qMonthStart}) OR (year=${qyearEnd} and month<=${qMonthEnd}));


hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthlySourceCountryDis;">/home/yaakov.tayeb/output/spree.tsv;

