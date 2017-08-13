DROP TABLE yaakovt.topsites;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.topsites (
    site string, 
    total_visits double,
    year int,
    month int
    ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.topsites
SELECT m.site,
       m.visits+d.estimatedvisits as total_visits,
       m.year,
       m.month
FROM mobile.snapshot_estimated_values AS m
INNER JOIN analytics.snapshot_estimated_values AS d ON (m.site=d.site
AND m.country=d.country
AND m.month=d.month
AND d.year=m.year)
WHERE m.country=999
AND m.year=17 and m.month=2 and
m.site in (
      SELECT concat(top.site,"*") FROM analytics.toplists as top WHERE top.country=999 and top.year=17 and top.month=2 and (top.rankcategory="ALL" or top.rankcategory="") and top.rank<=100
);


hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.topsites;">/home/yaakov.tayeb/output/topsites.tsv;

---Now let's go deeper
--Traffic sources
sites_distros

