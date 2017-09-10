drop table yaakovt.JohnLewisWeeklyDistro;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.JohnLewisWeeklyDistro(
site            string,
country         string,
weekbegins      string,
weekends        string,
direct          double,
displayads      double,
mail            double,
organic_search  double,
paid_search     double,
referrals       double,
social          double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/JohnLewisWeeklyDistro/';

set hivevar:weekbegins = '08.06.2017';
set hivevar:weekends = '08.12.2017';
set hivevar:lyweekbegins = '08.07.2016';
set hivevar:lyweekends = '08.13.2016';
set hivevar:day1 = 6;
set hivevar:day2 = 12;
set hivevar:month1 = 8;
set hivevar:month2 = 8;
set hivevar:year = 17;
set hivevar:lyday1 = 7;
set hivevar:lymonth1 = 8;
set hivevar:lyday2 = 13;
set hivevar:lymonth2 = 8;
set hivevar:lyyear = 16;

-- INSERT INTO yaakovt.JohnLewisWeeklyDistro
INSERT OVERWRITE TABLE yaakovt.JohnLewisWeeklyDistro
INSERT INTO yaakovt.JohnLewisWeeklyDistro
select  traffic.site,
        traffic.country,
        traffic.date1,
        traffic.date2,
        if(traffic.direct > 2*traffic.mail, (traffic.direct-2*traffic.mail)/traffic.totals, traffic.direct/traffic.totals),
        traffic.displayads/traffic.totals,
        if(traffic.direct > 2*traffic.mail, (traffic.mail*3)/traffic.totals, traffic.mail/traffic.totals),
        traffic.organic_search/traffic.totals,
        traffic.paid_search/traffic.totals,
        traffic.referrals/traffic.totals,
        traffic.social/traffic.totals
FROM
(SELECT
        a.site,
        b.country,
        ${weekbegins} as date1,
        ${weekends} as date2,
        sum(if(getTopSpecialReferrerUDF(b.refid)=5, visits, 0)) AS direct,
        sum(if(getTopSpecialReferrerUDF(b.refid)=4, visits, 0)) AS displayads,
        sum(if(getTopSpecialReferrerUDF(b.refid)=3, visits, 0)) AS mail,
        sum(if(getTopSpecialReferrerUDF(b.refid)=1 and refflag=0, visits, 0)) AS organic_search,
        sum(if(getTopSpecialReferrerUDF(b.refid)=1 and refflag=1, visits, 0)) AS paid_search,
        sum(if(getTopSpecialReferrerUDF(b.refid)=6, visits, 0)) AS referrals,
        sum(if(getTopSpecialReferrerUDF(b.refid)=2, visits, 0)) AS social,
        sum(b.visits) AS totals
FROM analytics.daily_estimated_totals_sr as b
inner join yaakovt.jlsites as a on (b.site=a.site)
WHERE b.year = ${year} and (b.month >= ${month1} and b.month<=${month2}) and (b.day>=${day1} and b.day<=${day2}) and b.country=999
group by a.site, b.country
) traffic;;

INSERT INTO yaakovt.JohnLewisWeeklyDistro
select  traffic.site,
        'WorldWide',
        traffic.date1,
        traffic.date2,
        if(traffic.direct > 2*traffic.mail, (traffic.direct-2*traffic.mail)/traffic.totals, traffic.direct/traffic.totals),
        traffic.displayads/traffic.totals,
        if(traffic.direct > 2*traffic.mail, (traffic.mail*3)/traffic.totals, traffic.mail/traffic.totals),
        traffic.organic_search/traffic.totals,
        traffic.paid_search/traffic.totals,
        traffic.referrals/traffic.totals,
        traffic.social/traffic.totals
FROM
(SELECT
        a.site,
        'WorldWide',
        ${lyweekbegins} as date1,
        ${lyweekends} as date2,
        sum(if(getTopSpecialReferrerUDF(b.specialref)=5, 1, 0)) AS direct,
        sum(if(getTopSpecialReferrerUDF(b.specialref)=4, 1, 0)) AS displayads,
        sum(if(getTopSpecialReferrerUDF(b.specialref)=3, 1, 0)) AS mail,
        sum(if(getTopSpecialReferrerUDF(b.specialref)=1 and reftype="ORGANIC", 1, 0)) AS organic_search,
        sum(if(getTopSpecialReferrerUDF(b.specialref)=1 and reftype="PAID", 1, 0)) AS paid_search,
        sum(if(getTopSpecialReferrerUDF(b.specialref)=6, 1, 0)) AS referrals,
        sum(if(getTopSpecialReferrerUDF(b.specialref)=2, 1, 0)) AS social,
        sum(1) AS totals
FROM ds.parquet_visits as b
inner join yaakovt.jlsites as a on (b.site=a.site)
WHERE b.year = ${lyyear} and (b.month >= ${lymonth1} and b.month<=${lymonth2}) and (b.day>=${lyday1} and b.day<=${lyday2}) and b.country<999
group by a.site
) traffic;;

-- hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.JohnLewisWeeklyDistro;">/home/yaakov.tayeb/output/JohnLewisWeeklyDistro130817.tsv;