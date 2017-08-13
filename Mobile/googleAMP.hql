set hivevar:qcountry = 826;
set hivevar:qsite = "%/amp/%totaljobs.co%";

drop TABLE yaakovt.googleAMP;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.googleAMP (
   site string,
   country int,
   source string,
   raw_pageviews double,
   year int,
   month int,
   day int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/googleAMP/';

INSERT INTO yaakovt.googleAMP
INSERT OVERWRITE TABLE yaakovt.googleAMP
select
    site,
    ${qcountry},
    0,
    count(site),
    year,
    month,
    day
FROM ds.parquet_visits_mobile WHERE
YEAR=17 AND MONTH>=6
AND concat_ws(',', pages) like ${qsite}
and site like "%google.%"
and country=${qcountry}
GROUP BY site, year, month, source, day;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.googleAMP;">/home/yaakov.tayeb/output/googleAMP.tsv;

