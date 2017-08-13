drop table yaakovt.GA_analysis;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.GA_analysis (
dt                        string,                                        
site                      string,                                        
country                   int,                                           
pageviewmobile            double,                                        
pageviewonline            double,                                        
uniqmobile                double,                                        
uniqonline                double,                                        
visitsmobile              double,                                        
visitsonline              double,                                        
year                      int,                                           
month                     int   
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/traffic/GA_analysis/';

drop table yaakovt.GA_analysis;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.GA_analysis (
dt                        string,                                        
site                      string,                                        
country                   int,                                           
pageviewmobile            double,                                        
pageviewonline            double,                                        
uniqmobile                double,                                        
uniqonline                double,                                        
visitsmobile              double,                                        
visitsonline              double,
source                    string,
weight                    double,
year                      int,                                           
month                     int,
panel_mobile_raw_visits          double,
panel_mobile_est_visits          double,
panel_desktop_raw_visits          double,
panel_desktop_est_visits          double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/traffic/GA_analysis/';

INSERT overwrite TABLE yaakovt.GA_analysis
SELECT a.*,
       b.raw_visits,
       b.visits,
       c.rawvisits as desktop_raw_visits,
       c.estimatedvisits as desktop_visits
FROM royy.all_learningset_data AS a
INNER JOIN mobile.snapshot_estimated_values AS b ON (a.site=b.site
                                                     AND a.month=b.month
                                                     AND a.year=b.year
                                                     AND a.country=b.country)
INNER JOIN analytics.snapshot_estimated_values AS c ON (c.site=a.site AND c.year = a.year AND c.country = a.country AND c.month=a.month)
WHERE a.year>=17
  AND a.country=208;

 hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.GA_analysis;">/home/yaakov.tayeb/output/denmark.market.gasw.tsv;

-- Run on daily data


INSERT overwrite TABLE yaakovt.GA_analysis
SELECT a.*,
       b.raw_visits,
       b.estimatedvisits,
       b.estimatedpageviews
FROM royy.all_learningset_data AS a
INNER JOIN (
select site, month, year, country,
       sum(rawvisits) as raw_visits,
       sum(estimatedvisits) as estimatedvisits,
       sum(estimatedpageviews) as estimatedpageviews
from analytics.daily_estimated_values
where year=17
group by site, month, year, country
) AS b
ON (a.site=b.site AND a.month=b.month
AND a.year=b.year
AND a.country=b.country)
WHERE a.year=17
  AND a.country=208;