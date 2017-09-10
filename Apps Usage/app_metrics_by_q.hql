drop table yaakovt.apps_usage_source;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.apps_usage_source (
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
month                 int,                                       
day                   int 
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/apps_usage_source/';

INSERT overwrite table yaakovt.apps_usage_source
SELECT * FROM mobile.daily_app_metrics
WHERE app IN ("com.bengalimatrimony", "com.marathimatrimony", "com.kannadamatrimony")
AND YEAR=16 and month=2 and country=356;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.apps_usage_source;">/home/yaakov.tayeb/output/indiasapps.tsv;
