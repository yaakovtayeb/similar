--Monthly:
set hivevar:qsite = 'zavvi.com';
set hivevar:qyearStart = 17;
set hivevar:qyearEnd = 17;
set hivevar:qMonthStart = 1;
set hivevar:qMonthEnd = 5;

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
SELECT site, country, 0, 0, visits, 0, year, month
FROM meta_ls_main.snapshot_estimated_values
WHERE (site=${qsite})
        AND ((YEAR=${qyearStart} and month>=${qMonthStart}) OR (year=${qyearEnd} and month<=${qMonthEnd}));

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthlyCountryDis;">/home/yaakov.tayeb/output/zavvi.com.tsv;
hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.visits;">/home/yaakov.tayeb/output/lookfantastic.fr_pages.tsv;

FROM meta_ls_main.snapshot_estimated_values