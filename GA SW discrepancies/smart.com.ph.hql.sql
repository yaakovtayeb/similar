DROP TABLE yaakovt.smart;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.smart (
	site string, 
	country int, 
	mobile_rawvisits double,
	mobile_visits double, 
	desktop_rawvisits double, 
	desktop_visits double, 
	YEAR int, 
	MONTH int
	) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';

INSERT OVERWRITE TABLE yaakovt.smart
SELECT d.site,
       d.country,
       m.raw_visits,
       m.visits,
       d.rawvisits,
       d.estimatedvisits,
       d.year,
       d.month
FROM analytics.snapshot_estimated_values AS d
FULL OUTER JOIN mobile.snapshot_estimated_values AS m ON (m.site=d.site
                                                        AND m.country=d.country
                                                        AND m.month=d.month
                                                        AND m.year=d.year)
WHERE d.site="smart.com.ph*"
        AND d.country=999
        AND ((d.year=16 and d.month>=2) OR (d.year=17 and d.month<3));


hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.smart;">/home/yaakov.tayeb/output/smart.tsv;
--select * from yaakovt.smart limit 10;
--suming the daily instead of the snapshot

