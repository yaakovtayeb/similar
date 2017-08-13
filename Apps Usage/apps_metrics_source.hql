drop table yaakovt.apps_metrics_source;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.apps_metrics_source (
app                   string,                            
source                int,                               
country               int,                               
devices               double,                            
users                 double,                            
dailyinstalls         double,                            
dailyuninstalls       double,                            
dailyupdates          double,                            
sessions              double,                            
usagetime             double,                            
sessionsquared        double,                            
realsessionsquared    double,                            
usagesquared          double,                            
isinstalled           double,                            
isuninstalled         double,                            
qualified_active_users  double,                            
year                  int,                               
month                 int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/apps_metrics_source/';

INSERT overwrite table yaakovt.apps_metrics_source
SELECT 
app,                                               
source,                                               
country,                                              
sum(devices), 
sum(users),
sum(dailyinstalls),                                     
sum(dailyuninstalls),                                   
sum(dailyupdates),
sum(sessions),
avg(usagetime),
sum(sessionsquared),                                    
sum(realsessionsquared),
sum(usagesquared),                              
sum(isinstalled),
sum(isuninstalled),                                     
sum(qualified_active_users), 
year,
month
FROM mobile.daily_app_metrics
WHERE (YEAR=17 OR (YEAR=16 AND MONTH>9))
        AND app IN ('com.bukalapak.android', 'com.tokopedia.tkpd', 'com.shopee.id')
        AND country=360
group by app, source, country, year, month;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.apps_metrics_source;">/home/yaakov.tayeb/output/apps_metrics_source.tsv;
