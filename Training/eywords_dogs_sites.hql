Drop table yaakovt.keywords_dogs_sites;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.keywords_dogs_sites (site string, keywords string, visits double) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.keywords_dogs_sites
  SELECT b.site, b.keywords, 'b.visits.estimatedValue' AS visits
   FROM analytics.snapshot_estimated_totals_incoming_keywords as b
WHERE b.referrer.refFlag=0
  AND b.YEAR=17
  AND b.MONTH=1
  AND b.country=999
  AND INSTR(b.site, '*')>0
  AND b.site IN
    (SELECT a.site
     FROM
       (SELECT site,
               visits.estimatedValue AS vis
        FROM analytics.snapshot_estimated_totals_incoming_keywords
        WHERE keywords="dogs"
          AND referrer.refFlag=0
          AND YEAR=17
          AND MONTH=1
          AND country=999
          AND INSTR(site,'*')>0
        ORDER BY vis DESC LIMIT 10) a)
ORDER BY visits DESC LIMIT 100;