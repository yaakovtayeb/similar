drop table yaakovt.visits;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.visits (
site                    string,
country                 int,
source                  int,
site2                   string,
traffic_source          int,
landingpage             string,
sendingpage             string,
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

set hivevar:qsite = 'eyebuydirect.com*';
set hivevar:qsite2 = '%glassesusa.com%';
set hivevar:qcountry = 840;
set hivevar:platform = "Desktop";

-- INSERT INTO yaakovt.visits
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
FROM ds.parquet_visits
WHERE (site like "%promo.pokermatch.com%" or site like "%start.parimatch.com%") and site2 like "%adv.fan-sport.club%" and year=17 and month=7 and getTopSpecialReferrerUDF(specialref)=6;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.visits;">/home/yaakov.tayeb/output/skybet.tsv;

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

--INSERT INTO yaakovt.clickstream_sample
INSERT overwrite TABLE yaakovt.clickstream_sample
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

-- INSERT INTO yaakovt.visits
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
FROM ds.parquet_visits
WHERE site="lookfantastic.fr*" and month=3 and year=17;