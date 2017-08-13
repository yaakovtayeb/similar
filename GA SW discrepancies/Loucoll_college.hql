DESC analytics.snapshot_estimated_values;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.loucoll_college (
site string,
country int,
rawunique double,
estimatedunique double,
varianceunique double,
rawvisits double,
estimatedvisits double,
variancevisits double,
rawpageviews double,
estimatedpageviews double,
variancepageviews double,
unadjustedunique double,
unadjustedvisits double,
onepagevisits double,
timeonsite double,
type string,
year int,
month int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/';

INSERT OVERWRITE TABLE yaakovt.loucoll_college
SELECT * 
FROM analytics.snapshot_estimated_values
WHERE YEAR=16
and (site="loucoll.ac.uk" or site="docs.loucoll.ac.uk")
AND country=999;

INSERT OVERWRITE TABLE yaakovt.loucoll_college
SELECT * 
FROM analytics.snapshot_estimated_values
WHERE YEAR=16
and (site="docs.loucoll.ac.uk#")
AND country=999;

-- Print

Select * from yaakovt.loucoll_college;
hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.loucoll_college;">/home/yaakov.tayeb/output/laredoute_outgoing.tsv;



