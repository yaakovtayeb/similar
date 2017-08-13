drop table yaakovt.app_metric;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.app_metric (
app                   string,                                    
country               int,                                       
raw_devices           double,                                    
raw_users             double,                                    
raw_installs          double,                                    
raw_uninstalls        double,                                    
raw_updates           double,                                    
raw_sessions          double,                                    
raw_usage_time        double,                                    
raw_sessions_squared  double,                                    
raw_real_sessions_squared double,                                    
raw_usage_squared     double,                                    
raw_is_installed      double,                                    
raw_is_uninstalled    double,                                    
raw_qualifying_as_active_users  double,                                    
reach                 double,                                    
active_users          double,                                    
sessions              double,                                    
usage_time            double,                                    
year                  int,                                       
month                 int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/app_metric/';  
 
INSERT overwrite TABLE yaakovt.app_metric
SELECT app,
       country,
       sum(raw_devices),
       sum(raw_users),
       sum(raw_installs),
       sum(raw_uninstalls),
       sum(raw_updates),
       sum(raw_sessions),
       avg(raw_usage_time),
       sum(raw_sessions_squared),
       sum(raw_real_sessions_squared),
       sum(raw_usage_squared),
       sum(raw_is_installed),
       sum(raw_is_uninstalled),
       sum(raw_qualifying_as_active_users),
       AVG(reach),
       AVG(active_users),
       sum(sessions),
       sum(usage_time)/sum(active_users),
       YEAR,
       MONTH
FROM mobile.daily_app_engagement_estimations
WHERE (YEAR=17
  OR (YEAR=16
      AND MONTH>9))
  AND app IN ('com.bukalapak.android',
              'com.tokopedia.tkpd',
              'com.shopee.id')
  AND country=360
GROUP BY app,
         country,
         YEAR,
         MONTH;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.app_metric;">/home/yaakov.tayeb/output/app_metric.tsv;
