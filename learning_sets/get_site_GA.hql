--Get a GA from our learning sets
set hivevar:qsite = 'spree.co.za';

drop table yaakovt.get_ga;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.get_ga (
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
LOCATION '/user/yaakov.tayeb/outputs/traffic/get_ga/';

--INSERT INTO yaakovt.get_ga
INSERT OVERWRITE TABLE yaakovt.get_ga
SELECT *
FROM royy.all_learningset_data
WHERE site=${qsite}
        AND ((YEAR=16 and month>=4) OR year=17);


hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.get_ga;">/home/yaakov.tayeb/output/spree_get_ga.tsv;
