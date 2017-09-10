--revitalizepg.com

-- General Metrics

SELECT
    site,
    estimatedvisits as visits,
    int(timeonsite/60) as visit_duration,
    estimatedpageviews/estimatedvisits as pages_per_visit,
    onepagevisit / rawvisits as bounce_rate,
    estimatedunique as Uniquevisitors,
    year,
    month,
    day
FROM analytics.daily_estimated_values
WHERE site = 'revitalizepg.com*'
      and year=17
      and ((month=7 and day>15) or month=8)
      and country=999;

hive -e "set hive.cli.print.header=true; SELECT
    site,
    estimatedvisits as visits,
    int(timeonsite/60) as visit_duration,
    estimatedpageviews/estimatedvisits as pages_per_visit,
    onepagevisit / rawvisits as bounce_rate,
    estimatedunique as Uniquevisitors,
    year,
    month,
    day
FROM analytics.daily_estimated_values
WHERE site = 'revitalizepg.com*'
      and year=17
      and ((month=7 and day>15) or month=8)
      and country=999;">/home/yaakov.tayeb/output/revitalizepg_com/general_metrics.tsv;

--- general metrics mobile

SELECT
    site,
    visits as visits,
    raw_visitduration,
    raw_pageviews/raw_visits as pages_per_visit,
    raw_onepagevisits / raw_visits as bounce_rate,
    unique as Uniquevisitors,
    year,
    month,
    day
FROM mobile.window_estimated_values
WHERE site = 'revitalizepg.com*'
      and country=999;




---- Traffic Sources
select
    a.site,
    if(a.source=1 and a.refflag=1, 7, a.source),
    a.visits,
    a.pageviews,
    a.bouncerate,
    a.visitDurartion
FROM
(select
    site,
    getTopSpecialReferrerUDF(refid) as source,
    refflag,
    sum(estimatedvisits) as Visits,
    sum(estimatedpageviews) as Pageviews,
    Sum(onepagevisits)/sum(visits) as bouncerate,
    AVG(timeonsite) as visitDurartion
FROM analytics.window_estimated_totals_sr
WHERE site='revitalizepg.com*'
and country=999
GROUP BY site, getTopSpecialReferrerUDF(refid), refflag) a;


hive -e "set hive.cli.print.header=true; select
    a.site,
    if(a.source=1 and a.refflag=1, 7, a.source),
    a.visits,
    a.pageviews,
    a.bouncerate,
    a.visitDurartion
FROM
(select
    site,
    getTopSpecialReferrerUDF(refid) as source,
    refflag,
    sum(estimatedvisits) as Visits,
    sum(estimatedpageviews) as Pageviews,
    Sum(onepagevisits)/sum(visits) as bouncerate,
    AVG(timeonsite) as visitDurartion
FROM analytics.window_estimated_totals_sr
WHERE site='revitalizepg.com*'
and country=999
GROUP BY site, getTopSpecialReferrerUDF(refid), refflag) a;">/home/yaakov.tayeb/output/revitalizepg_com/traffic_sources.tsv;

----- Referrals:

select b.refsite, b.siteshare/b.alltraffic as traffic_share from
(select a.site2 as refsite, a.trafficshare as siteshare, sum(a.trafficshare) over () as alltraffic  from
(select
        site2,
        sum(visits) as trafficshare
from analytics.window_incoming_referral
where site = 'revitalizepg.com*'
and country<999 and getTopSpecialReferrerUDF(refid)=6
group by site2) a) b;


hive -e "set hive.cli.print.header=true; select b.refsite, b.siteshare/b.alltraffic as traffic_share from
(select a.site2 as refsite, a.trafficshare as siteshare, sum(a.trafficshare) over () as alltraffic  from
(select
        site2,
        sum(visits) as trafficshare
from analytics.window_incoming_referral
where site = 'revitalizepg.com*'
and country<999 and getTopSpecialReferrerUDF(refid)=6
group by site2) a) b;">/home/yaakov.tayeb/output/revitalizepg_com/referrals.tsv;

---- Keywords

select a.keywords, a.key_visits / sum(a.key_visits) over () as share from
(select
        keywords,
        sum(visits) as key_visits
from analytics.window_incoming_keywords
where site = 'revitalizepg.com*'
and country<999
group by keywords) a;


hive -e "set hive.cli.print.header=true; select a.keywords, a.key_visits / sum(a.key_visits) over () as share from
(select
        keywords,
        sum(visits) as key_visits
from analytics.window_incoming_keywords
where site = 'revitalizepg.com*'
and country<999
group by keywords) a;">/home/yaakov.tayeb/output/revitalizepg_com/keywords.tsv;

--- Outgoing links

select b.refsite, b.siteshare/b.alltraffic as traffic_share from
(select a.site as refsite, a.trafficshare as siteshare, sum(a.trafficshare) over () as alltraffic  from
(select
        site,
        sum(visits) as trafficshare
from analytics.window_incoming_referral
where site2 like '%revitalizepg.com%' and instr(site, '*')=0
and country<999 and getTopSpecialReferrerUDF(refid)=6
group by site) a) b;


hive -e "set hive.cli.print.header=true; select b.refsite, b.siteshare/b.alltraffic as traffic_share from
(select a.site as refsite, a.trafficshare as siteshare, sum(a.trafficshare) over () as alltraffic  from
(select
        site,
        sum(visits) as trafficshare
from analytics.window_incoming_referral
where site2 like '%revitalizepg.com%' and instr(site, '*')=0
and country<999 and getTopSpecialReferrerUDF(refid)=6
group by site) a) b;">/home/yaakov.tayeb/output/revitalizepg_com/outgoing_links.tsv;

-- Popularpages

select a.page, a.pageviews/a.totalpageviews as share
from
(select
    page,
    pageviews,
    sum(pageviews) over () as totalpageviews
from analytics.window_popular_pages_with_totals
where
    site = 'revitalizepg.com*'
    and country=999) a;

hive -e "set hive.cli.print.header=true; select b.page, b.n/b.all as share
from
(select a.page as page, a.pageviews as n, sum(a.pageviews) over () as all from
(select
    page,
    sum(pageviews) as pageviews
from analytics.window_popular_pages_with_totals
where
    site = 'revitalizepg.com*'
    and country=999 group by page) a) b;">/home/yaakov.tayeb/output/revitalizepg_com/popularpages.tsv;;