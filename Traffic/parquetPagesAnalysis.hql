

drop TABLE yaakovt.pages;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.pages (
   site string,
   country int,
   source string,
   pages array<string>,
   year int,
   month int,
   day int,
   user string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/pages/';

set hivevar:qcountry = 840;
set hivevar:qsite = "%disneystore.co.uk%";

-- INSERT INTO yaakovt.pages
INSERT OVERWRITE TABLE yaakovt.pages
select
    site,
    country,
    source,
    pages,
    year,
    month,
    day,
    user
FROM ds.parquet_visits_mobile WHERE
YEAR=16 AND MONTH>=10
AND concat_ws(',', pages) like ${qsite};

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.pages">/home/yaakov.tayeb/output/disneystore.fr.tsv;

