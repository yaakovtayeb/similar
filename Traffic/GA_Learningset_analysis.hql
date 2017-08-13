--Learning sets:

drop table yaakovt.ga_learningset;
create external table if not EXISTS yaakovt.ga_learningset (
dt                      string,
site                    string,
country                 int,
pageviewmobile          double,
pageviewonline          double,
uniqmobile              double,
uniqonline              double,
visitsmobile            double,
visitsonline            double,
year                    int,
month                   int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/ga_learningset/';

INSERT OVERWRITE TABLE yaakovt.ga_learningset
SELECT *
FROM royy.all_learningset_data
WHERE SITE="urlaubsguru.de"
        AND YEAR=16;

---
--- FINDING OUR DATA
---

--Monthly:

DROP TABLE yaakovt.ga_learningset_sw;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.ga_learningset_sw (
  site string, 
  country int,
  platform string, 
  rawvisits double, 
  estimatedvisits double, 
  YEAR int, 
  MONTH int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/ga_learningset_sw/';

INSERT OVERWRITE TABLE yaakovt.ga_learningset_sw
SELECT d.site,
       d.country,
       'desktop',
       d.rawvisits,
       d.estimatedvisits, 
       d.year,
       d.month
FROM analytics.snapshot_estimated_values AS d
        WHERE d.site="urlaubsguru.de*"
        AND d.country=999
        AND d.year=16;

INSERT INTO yaakovt.ga_learningset_sw
SELECT m.site,
       m.country,
       'mobile',
       m.raw_visits,
       m.visits, 
       m.year,
       m.month
FROM mobile.snapshot_estimated_values AS m
        WHERE m.site="urlaubsguru.de*"
        AND m.country=999
        AND m.year=16;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.ga_learningset;">/home/yaakov.tayeb/output/ga_learningset_urlaubsguru.tsv;
hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.ga_learningset_sw;">/home/yaakov.tayeb/output/urlaubsguru_sw.tsv;
