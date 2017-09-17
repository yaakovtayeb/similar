-- SET mapred.job.queue.name = root.research_shared;

drop table yaakovt.visits;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.visits (
site                    string,
country                 int,
source                  int,
site2                   string,
traffic_source          int,
landingpage             string,
sendingpage             string,
keywords                string,
user                    string,
pages                   array<string>,
timestamps              array<bigint>,
refpath                 array<string>,
year                    int,
month                   int,
day                     int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/traffic/visits/';

set hivevar:qsite = 'creditmutuel.fr*';
set hivevar:qsite2 = '%glassesusa.com%';
set hivevar:qcountry = 250;
set hivevar:platform = "Desktop";

-- INSERT INTO yaakovt.visits
INSERT OVERWRITE TABLE yaakovt.visits
SELECT site,
       country,
       source,
       site2,
       -- getTopSpecialReferrerUDF(specialref) as traffic_source,
       specialref,
       landingpage,
       sendingpage,
       keywords,
       USER,
       pages,
       timestamps,
       refpath,
       YEAR,
       MONTH,
       DAY
FROM ds.parquet_visits
WHERE site=${qsite} and specialref=6 and year=17 and month=9 and day=15;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.visits;">/home/yaakov.tayeb/output/ebay-amazon.guitar.tsv;

--Click Stream

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.clickstream_sample (
ts                      string,
source_id               int,
sub_id                  string,
user_id                 string,
session_id              string,
user_ip                 string,
country_id              int,
user_agent              string,
is_from_one_way         string,
is_link                 string,
http_referer            string,
previous_site           string,
requested_site          string,
http_code               string,
http_redirect_to_url    string,
content_type            string,
application_name        string,
is_from_browser         string,
version                 string,
client_redirect         string,
client_redirect_duration        string,
version_number          string,
server_redirect         string,
ip_hash                 string,
year                    int,
month                   int,
day                     int,
app                     string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/clickstream_sample/';

msck repair table desktop_panel.desktop_raw_stats;

INSERT overwrite TABLE yaakovt.clickstream_sample
--INSERT INTO yaakovt.clickstream_sample
SELECT *
FROM desktop_panel.desktop_raw_stats
WHERE YEAR=17
        AND MONTH=7 AND (DAY=9)
        AND user_id IN ('bil5ohl8ko19ab0613a986d7nie')
ORDER BY user_id,
         ts;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.clickstream_sample;">/home/yaakov.tayeb/output/flowers.tsv;

-- Mobile --



set hivevar:qsite = 'prakard.com';
set hivevar:qsite2 = 'sarahsflowers.com.au';
set hivevar:qcountry = 392;
set hivevar:platform = "Desktop";

INSERT INTO yaakovt.visits
INSERT OVERWRITE TABLE yaakovt.visits
SELECT site,
       country,
       source,
       site2,
       --getTopSpecialReferrerUDF(specialref) as traffic_source,
       specialref,
       landingpage,
       sendingpage,
       USER,
       pages,
       timestamps,
       refpath,
       YEAR,
       MONTH,
       DAY
FROM ds.parquet_visits_mobile
WHERE site="foodeliciouz.com*" and month>2 and year=17;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.visits;">/home/yaakov.tayeb/output/sdvor.tsv;


filedate=$(date +%d%m%y)
hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.JohnLewisWeeklyDistro;">home/yaakov.tayeb/output/JohnLewisWeeklyDistro${filedate}.tsv;

hive -f "set hive.cli.print.header=true; SELECT * FROM yaakovt.JohnLewisWeeklyDistro;">/similargroup/prod_research/yaakov.tayeb/J1.tsv;