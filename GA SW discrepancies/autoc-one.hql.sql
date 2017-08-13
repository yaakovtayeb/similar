DROP TABLE yaakovt.autoc_one;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.autoc_one (site string, country int, mobile_rawvisits double, mobile_visits double, desktop_rawvisits double, desktop_visits double, YEAR int, MONTH int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';

INSERT OVERWRITE TABLE yaakovt.autoc_one
SELECT d.site,
       d.country,
       m.raw_visits,
       m.visits,
       d.rawvisits,
       d.estimatedvisits,
       d.year,
       d.month
FROM mobile.snapshot_estimated_values AS m
FULL OUTER JOIN analytics.snapshot_estimated_values AS d ON (d.site=m.site
                                                             AND d.country=m.country
                                                             AND d.MONTH=m.MONTH
                                                             AND d.YEAR=m.YEAR)
WHERE d.site IN ("minkara.carview.co.jp*",
                  "carsensor.net*",
                  "autoc-one.jp*",
                  "toyota.jp*",
                  "goo-net.com*",
                  "honda.co.jp*",
                  "response.jp*",
                  "carview.yahoo.co.jp#",
                  "driveplaza.com*",
                  "car.watch.impress.co.jp#")
        AND d.country=999
        AND d.YEAR=16;

  hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.autoc_one;">/home/yaakov.tayeb/output/autoc_one.tsv;

  --QA
  --select rawvisits from analytics.snapshot_estimated_values WHERE site="autoc-one.jp" and month=6 and year=16 and country=999;
