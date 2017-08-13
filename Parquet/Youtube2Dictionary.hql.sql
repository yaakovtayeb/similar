--Find something in the Parquet

SELECT *
FROM ds.parquet_visits
WHERE site="dictionary.com*"
        AND site2="youtube.com"
        AND YEAR=17
        AND MONTH=2
        LIMIT 5;






---- No 999 in parquet visits.

--FIND ME THE CLICKSTREAM 
drop table yaakovt.youtube2dictionarycom_cs;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.youtube2dictionarycom_cs (
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
LOCATION '/user/yaakov.tayeb/outputs/youtube2dic';

INSERT OVERWRITE TABLE yaakovt.youtube2dictionarycom_cs
SELECT *
FROM desktop_panel.desktop_raw_stats
WHERE YEAR=17
        AND MONTH=2
        AND (DAY=5 or Day=6)
        AND user_id IN ('rwxwosuGpz4IoL1',
'GzfxZmUzu1uAZ1QYtaOCoGELlYkPltUa',
'qLNzvMnphyelFM3pqHJzcTudTbX5a7QA',
'm5p7UMp2CTqxkK3qGgPB0or9Vm9UuUf6',
'mZ8oecBaL4OPrdebCTuYtlLzS5Y9OHJx');

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.youtube2dictionarycom_cs;">/home/yaakov.tayeb/output/youtube2dictionarycom_cs.tsv;

