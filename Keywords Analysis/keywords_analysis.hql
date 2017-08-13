DROP TABLE yaakovt.keywords_analysis;

Create EXTERNAL TABLE IF NOT EXISTS yaakovt.keywords_analysis (
site                    string,
country                 bigint,
referrer                struct<refID:int,refFlag:int>,
keywords                string,
visits                  struct<originalValue:double,estimatedValue:double>,
pageviews               struct<originalValue:double,estimatedValue:double>,
onepagevisits           double,
timeonsite              double,
type                    string,
year                    int,
month                   int) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/keywords_analysis/';

set hivevar:qsite = 'jcpenney.com*';
set hivevar:qcountry = 999;

INSERT OVERWRITE TABLE yaakovt.keywords_analysis
INSERT INTO yaakovt.keywords_analysis
SELECT *
FROM analytics.snapshot_estimated_totals_incoming_keywords
WHERE site=${qsite}
and country=${qcountry}
        AND MONTH=12
        AND YEAR=16;
        AND keywords in ();



INSERT INTO yaakovt.keywords_analysis
SELECT *
FROM analytics.snapshot_estimated_totals_incoming_keywords
WHERE site=${qsite}
        AND MONTH=12
        AND YEAR=16
        and country=${qcountry}
        AND keywords="123rf.com";

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.keywords_analysis;">/home/yaakov.tayeb/output/indiefit.com.tsv;

select *  
FROM ds.parquet_visits
WHERE site=${qsite}
and keywords="movie industry revenue 2016"
        AND YEAR=17
        and country=${qcountry}
        AND MONTH=4;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.keywords_calendar_sites;">/home/yaakov.tayeb/output/keywords_calendar_sites.tsv;

--In addition, check for any search visit of "photo calendar"
--Even if it is not from the top 10

SELECT results.site,
       results.YEAR,
               results.MONTH,
                       sum(results.visits.estimatedValue) AS rvisits 
FROM analytics.snapshot_estimated_totals_incoming_keywords AS results
WHERE results.keywords="photo calendar"
  AND results.year=16
  AND (results.MONTH=9 or results.month=8)
  AND results.country=840
  group by results.site, results.year, results.month;

--Results:
-- quill.com	16	9	104.33158987616338

SELECT results.site,
       results.YEAR,
              results.MONTH,
                       results.keywords,
                       sum(results.visits.estimatedValue) AS rvisits
FROM analytics.snapshot_estimated_totals_incoming_keywords AS results
WHERE results.keywords like "%photo calendar%"
  AND results.year=16
  AND (results.month=8)
  AND results.country=840
  group by results.site, results.year, results.month, results.keywords;




 --AND INSTR(site,'*')>0