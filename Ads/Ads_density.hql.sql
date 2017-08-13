desc analytics.snapshot_estimated_totals_incoming_referral;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.houzz_com_ads (
	site string, 
	country int, 
	ref_name string, 
	estimatedvisits int,
	month int,
	year int
	) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/houzz_com_ads_20317/';

INSERT OVERWRITE TABLE yaakovt.houzz_com_ads
SELECT site,
       country,
       getSpecialReferrerNameUDF(refid) as ref_name,
       Sum(estimatedvisits) as visits,
       MONTH,
       YEAR
FROM analytics.snapshot_estimated_totals_incoming_referral
WHERE SITE="houzz.com*"
        AND refflag=1
        AND getTopSpecialReferrerUDF(refid)=4
        AND YEAR=17
        AND MONTH=2
        AND country=999
GROUP BY site, country, getSpecialReferrerNameUDF(refid), month, year;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.houzz_com_ads;">/home/yaakov.tayeb/output/houzz_com_ads.tsv;