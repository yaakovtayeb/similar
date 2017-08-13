DESC ds.parquet_visits;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.laredoute_outgoing (site string, country int, city string, SOURCE string, specialref int, refpage string, refpath array<string>, reftype string, site2 string, landingpage string, sendingpage string, keywords string, timeonsite bigint, USER string, pages array<string>, timestamps array<bigint>, issitereferral boolean, userip string, YEAR int, MONTH int, DAY int) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.laredoute_outgoing
SELECT * 
FROM ds.parquet_visits
WHERE YEAR=17
  and month=2 and day=19 
  AND site="r.twenga.fr"
  AND site2="laredoute.fr";

 -- clickstream on hive;
 -- table: desktop_panel.desktop_raw_stats
 
hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.laredoute_outgoing;">/home/yaakov.tayeb/output/laredoute_outgoing.tsv;

--FIND ME THE CLICKSTREAM 

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.laredoute_outgoing_clickstream (ts string, user_id string, country_id int, http_referer string, previous_site string, requested_site string, client_redirect string, server_redirect string) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.laredoute_outgoing_clickstream
select ts, user_id, country_id, http_referer,previous_site ,requested_site, client_redirect, server_redirect from desktop_panel.desktop_raw_stats 
where year=17 and month=2 and day=19 and user_id in ('IzumqJwfGT9nx31gy7XGQWC6fbZ2GNz7',
'GGKtpxIpuKvuywE',
'af988f229f6e77916c890269c56272424f09e8f2',
'6f38ce82fe244008fbc93358ab4910438075fc8a',
'e462bsbmdrc7rfbc77rtimp7jc4',
'FKZ68L3pUYj8UP2ZAqLZKoeL61fAMuoH',
'flbee7pqid7328611ogl4a5l87o',
'qHzmBxrW3RC58De',
'4773ee046ce78c7d2caa241a681bffb4a7c874c9');

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.laredoute_outgoing_clickstream;">/home/yaakov.tayeb/output/laredoute_outgoing_clickstream.tsv;