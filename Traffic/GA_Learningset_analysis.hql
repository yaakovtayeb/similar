--Learning sets:

drop table yaakovt.ga_learningset;
create external table if not EXISTS yaakovt.ga_learningset (
site                    string,
country                 int,
pageviewmobile          double,
pageviewonline          double,
uniqmobile              double,
uniqonline              double,
visitsmobile            double,
visitsonline            double,
est_visits_mobile       double,
est_visits_desktop      double,
year                    int,
month                   int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/ga_learningset/';

INSERT OVERWRITE TABLE yaakovt.ga_learningset
SELECT *
FROM royy.all_learningset_data
WHERE SITE="spree.co.za*"
        AND YEAR=17;

---
--- FINDING OUR DATA
---

--Monthly:

set hivevar:qsite = 'spree.co.za*';

INSERT OVERWRITE TABLE yaakovt.ga_learningset
SELECT  ga.site,
        ga.country,
        sum(ga.pageviewmobile),
        sum(ga.pageviewonline),
        sum(ga.uniqmobile),
        sum(ga.uniqonline),
        sum(ga.visitsmobile),
        sum(ga.visitsonline),
        sum(dest.estimatedvisits),
        sum(mest.visits),
        ga.month,
        ga.year
FROM analytics.merged_learningset as ga
INNER JOIN analytics.snapshot_estimated_values AS dest
ON (dest.site = concat(ga.site, '*') AND dest.month = ga.month
    and dest.year = ga.year and dest.country=ga.country)
INNER JOIN mobile.snapshot_estimated_values as mest
ON (mest.site = concat(ga.site, '*') AND
    mest.month = ga.month
    and mest.year = ga.year
    and mest.country = ga.country)
WHERE dest.country=643
and dest.year=17 and dest.month>3
group by ga.site, ga.country, ga.month, ga.year;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.ga_learningset;">/home/yaakov.tayeb/output/russia_ga_sw.tsv;
