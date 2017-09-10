---- General

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

--- mobile general

hive -e "set hive.cli.print.header=true; SELECT
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
      and country=999;">/home/yaakov.tayeb/output/revitalizepg_com/general_metrics_mobile.tsv;


--- Traffic sources

hive -e "set hive.cli.print.header=true;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/JRI-1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/sql2o-1.2.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/blueprints-core-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/common-1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/commons-dbcp-1.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/commons-math3-3.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/uadetector-core-0.9.22.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/commons-pool-1.5.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/concurrentlinkedhashmap-lru-1.4.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/core-math-1.2.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/uadetector-resources-2014.10.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/couchbase-client-1.4.10.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/elasticsearch-1.1.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/etcd4j-2.7.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/slf4j-log4j12-1.7.5.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/external-services-1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gelfj-1.1.7.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/geoip2-0.7.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/google-http-client-1.20.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gov.nist.math.jama-1.1.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gremlin-groovy-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gremlin-java-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/groovy-1.8.9.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/guava-11.0.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/httpcore-4.4.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/httpcore-nio-4.4.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jackson-annotations-2.2.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jackson-core-2.2.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jackson-databind-2.2.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/javassist-3.12.1.GA.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jdom2-2.0.5.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jedis-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jna-4.0.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/joda-time-1.6.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/json-simple-1.1.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/libthrift-0.9.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/linq4j-1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/log4j-1.2.17.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/lucene-core-4.7.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/mail-1.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/maxminddb-0.3.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/mtj-1.0.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/spymemcached-2.12.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/mysql-connector-java-5.1.37.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/simple-xml-2.6.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/opencsv-2.3.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/orientdb-core-2.1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/orientdb-graphdb-2.1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/pipes-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/quality-check-1.3.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/reflections-0.9.9-RC1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/analytics-sources.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/analytics.jar;
create temporary function getTopSpecialReferrerUDF as 'com.similargroup.common.hive.udfs.getTopSpecialReferrerUDF';
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
GROUP BY site, getTopSpecialReferrerUDF(refid), refflag) a;">/home/yaakov.tayeb/output/revitalizepg_com/traffic_sources.tsv;

---  referrals

hive -e "set hive.cli.print.header=true;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/JRI-1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/sql2o-1.2.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/blueprints-core-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/common-1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/commons-dbcp-1.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/commons-math3-3.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/uadetector-core-0.9.22.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/commons-pool-1.5.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/concurrentlinkedhashmap-lru-1.4.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/core-math-1.2.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/uadetector-resources-2014.10.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/couchbase-client-1.4.10.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/elasticsearch-1.1.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/etcd4j-2.7.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/slf4j-log4j12-1.7.5.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/external-services-1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gelfj-1.1.7.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/geoip2-0.7.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/google-http-client-1.20.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gov.nist.math.jama-1.1.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gremlin-groovy-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gremlin-java-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/groovy-1.8.9.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/guava-11.0.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/httpcore-4.4.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/httpcore-nio-4.4.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jackson-annotations-2.2.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jackson-core-2.2.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jackson-databind-2.2.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/javassist-3.12.1.GA.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jdom2-2.0.5.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jedis-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jna-4.0.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/joda-time-1.6.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/json-simple-1.1.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/libthrift-0.9.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/linq4j-1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/log4j-1.2.17.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/lucene-core-4.7.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/mail-1.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/maxminddb-0.3.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/mtj-1.0.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/spymemcached-2.12.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/mysql-connector-java-5.1.37.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/simple-xml-2.6.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/opencsv-2.3.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/orientdb-core-2.1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/orientdb-graphdb-2.1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/pipes-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/quality-check-1.3.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/reflections-0.9.9-RC1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/analytics-sources.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/analytics.jar;
create temporary function getTopSpecialReferrerUDF as 'com.similargroup.common.hive.udfs.getTopSpecialReferrerUDF';
select b.refsite, b.siteshare/b.alltraffic as traffic_share from
(select a.site2 as refsite, a.trafficshare as siteshare, sum(a.trafficshare) over () as alltraffic  from
(select
        site2,
        sum(visits) as trafficshare
from analytics.window_incoming_referral
where site = 'revitalizepg.com*'
and country<999 and getTopSpecialReferrerUDF(refid)=6
group by site2) a) b;">/home/yaakov.tayeb/output/revitalizepg_com/referrals.tsv;

----- keywords

hive -e "set hive.cli.print.header=true; select a.keywords, a.key_visits / sum(a.key_visits) over () as share from
(select
        keywords,
        sum(visits) as key_visits
from analytics.window_incoming_keywords
where site = 'revitalizepg.com*'
and country<999
group by keywords) a;">/home/yaakov.tayeb/output/revitalizepg_com/keywords.tsv;

-----  outgoing links

hive -e "set hive.cli.print.header=true;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/JRI-1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/sql2o-1.2.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/blueprints-core-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/common-1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/commons-dbcp-1.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/commons-math3-3.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/uadetector-core-0.9.22.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/commons-pool-1.5.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/concurrentlinkedhashmap-lru-1.4.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/core-math-1.2.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/uadetector-resources-2014.10.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/couchbase-client-1.4.10.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/elasticsearch-1.1.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/etcd4j-2.7.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/slf4j-log4j12-1.7.5.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/external-services-1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gelfj-1.1.7.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/geoip2-0.7.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/google-http-client-1.20.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gov.nist.math.jama-1.1.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gremlin-groovy-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/gremlin-java-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/groovy-1.8.9.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/guava-11.0.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/httpcore-4.4.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/httpcore-nio-4.4.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jackson-annotations-2.2.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jackson-core-2.2.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jackson-databind-2.2.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/javassist-3.12.1.GA.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jdom2-2.0.5.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jedis-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/jna-4.0.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/joda-time-1.6.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/json-simple-1.1.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/libthrift-0.9.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/linq4j-1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/log4j-1.2.17.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/lucene-core-4.7.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/mail-1.4.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/maxminddb-0.3.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/mtj-1.0.1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/spymemcached-2.12.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/mysql-connector-java-5.1.37.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/simple-xml-2.6.2.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/opencsv-2.3.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/orientdb-core-2.1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/orientdb-graphdb-2.1.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/pipes-2.6.0.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/quality-check-1.3.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/reflections-0.9.9-RC1.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/analytics-sources.jar;
add jar hdfs:////similargroup/jars/mobile/daily/mobile/2016-04-30/2016-05-01-06-47-58-254/mobile-web/analytics.jar;
create temporary function getTopSpecialReferrerUDF as 'com.similargroup.common.hive.udfs.getTopSpecialReferrerUDF';
select b.refsite, b.siteshare/b.alltraffic as traffic_share from
(select a.site as refsite, a.trafficshare as siteshare, sum(a.trafficshare) over () as alltraffic  from
(select
        site,
        sum(visits) as trafficshare
from analytics.window_incoming_referral
where site2 like '%revitalizepg.com%' and instr(site, '*')=0
and country<999 and getTopSpecialReferrerUDF(refid)=6
group by site) a) b;">/home/yaakov.tayeb/output/revitalizepg_com/outgoing_links.tsv;

----- popular pages


hive -e "set hive.cli.print.header=true; select a.page, a.pageviews/a.totalpageviews as share
from
(select
    page,
    pageviews,
    sum(pageviews) over () as totalpageviews
from analytics.window_popular_pages_with_totals
where
    site = 'revitalizepg.com*'
    and country=999) a;">/home/yaakov.tayeb/output/revitalizepg_com/popularpages.tsv;