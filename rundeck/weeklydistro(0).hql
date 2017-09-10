create temporary function getTopSpecialReferrerUDF as 'com.similargroup.common.hive.udfs.getTopSpecialReferrerUDF';

msck repair table analytics.daily_estimated_totals_sr;
msck repair table analytics.daily_estimated_values;
msck repair table ds.parquet_visits;

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
social          double,
visits          double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/JohnLewisWeeklyDistro/';

set hivevar:weekbegins = 'q1';
set hivevar:weekends = 'q2';
set hivevar:lyweekbegins = 'q3';
set hivevar:lyweekends = 'q4';
set hivevar:day1 = q5;
set hivevar:day2 = q6;
set hivevar:month1 = q7;
set hivevar:month2 = q8;
set hivevar:year = q9;
set hivevar:lyday1 = qa10;
set hivevar:lymonth1 = qa11;
set hivevar:lyday2 = qa12;
set hivevar:lymonth2 = qa13;
set hivevar:lyyear = qa14;

INSERT OVERWRITE TABLE yaakovt.JohnLewisWeeklyDistro
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
        traffic.social/traffic.totals,
        traffic.esttotals
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
        sum(b.visits) as totals,
        sum(b.estimatedvisits) AS esttotals
FROM analytics.daily_estimated_totals_sr as b
inner join yaakovt.jlsites as a on (b.site=a.site)
WHERE b.year = ${year} and b.country=999
and ((b.month = ${month1} and b.day>=${day1} and b.day<=(${day1}+6)) or (b.month = ${month2} and b.day>=(${day2}-6) and b.day<=${day2}))
group by a.site, b.country
) traffic;

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
        traffic.social/traffic.totals,
        traffic.esttotals
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
        sum(1) as totals,
        c.visits AS esttotals
FROM ds.parquet_visits as b
inner join yaakovt.jlsites as a on (b.site=a.site)
INNER JOIN (select c.site, sum(c.estimatedvisits) as visits from analytics.daily_estimated_values as c WHERE c.country="999" and c.year = ${lyyear} and (c.month >= ${lymonth1} and c.month<=${lymonth2}) and (c.day>=${lyday1} and c.day<=${lyday2}) group by c.site) c ON (c.site = a.site)
WHERE b.year = ${lyyear} and b.country<999
and ((b.month = ${month1} and b.day>=${day1} and b.day<=(${day1}+6)) or (b.month = ${month2} and b.day>=(${day2}-6) and b.day<=${day2}))
group by a.site, c.visits
) traffic;