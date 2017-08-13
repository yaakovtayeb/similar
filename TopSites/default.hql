DROP TABLE yaakovt.temp;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.temp (
    site            string,
    allvisits       double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/temp';

insert overwrite table yaakovt.temp
select desktop.site, (desktop.desktopvisits + mobile.mobilevisits) AS allvisits FROM
(select site, sum(estimatedvisits) as desktopvisits
 from analytics.daily_estimated_totals_sr
 where site like "%.tumblr.com%"
 and year=17
 and country=999
 and month=5
 and instr(site, "#") = 0
group by site
) desktop
LEFT JOIN
(select site, sum(visits) as mobilevisits
 from mobile.daily_site_ww_adjusted_estimations
 where site like "%.tumblr.com%"
 and year=17
 and month=5
 and country=999
 and instr(site, "#") = 0
group by site) mobile
ON (
    desktop.site=mobile.site
)
ORDER by allvisits DESC
LIMIT 200000;

INSERT OVERWRITE TABLE yaakovt.topSitesByTraffic
SELECT
    a.site,
    a.rankcategory,
    a.sitecategory,
    b.allvisits as traffic,
    a.month,
    a.year
from analytics.toplists as a
INNER JOIN yaakovt.temp AS b ON (a.site=b.site)
WHERE a.month=5 and a.year=17 and rankcategory="ALL" and a.country=999;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.topSitesByTraffic;">/home/yaakov.tayeb/output/tumblrAnalytics.tsv;
