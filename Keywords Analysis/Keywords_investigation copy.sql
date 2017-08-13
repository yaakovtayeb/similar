DROP TABLE yaakovt.keywords_calendar_sites;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.keywords_calendar_sites (site string, YEAR int, MONTH int, visits double) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/';
INSERT OVERWRITE TABLE yaakovt.keywords_calendar_sites
SELECT results.site,
       results.YEAR,
               results.MONTH,
                       sum(results.visits.estimatedValue) AS rvisits 
FROM analytics.snapshot_estimated_totals_incoming_keywords AS results
WHERE results.keywords="photo calendar"
  AND ((results.YEAR=16
        AND results.MONTH>=8)
       OR (results.MONTH=1
           AND results.YEAR=17))
  AND results.country=840
  AND results.site IN
    ( SELECT b.site
     FROM
       (SELECT site,
               sum(visits.estimatedValue) AS visits
        FROM analytics.snapshot_estimated_totals_incoming_keywords
        WHERE keywords="photo calendar"
          AND ((YEAR=16
                AND MONTH>=8)
               OR (MONTH=1
                   AND YEAR=17))
          AND country=840
          AND INSTR(site,'*')=0
          AND INSTR(site,'#')=0
        GROUP BY site
        ORDER BY visits DESC LIMIT 10) b)
group by results.site, results.year, results.month;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.keywords_calendar_sites;">/home/yaakov.tayeb/output/keywords_calendar_sites.tsv;

--In addition, check for any search visit of "photo calendar"
--Even if it is not from the top 10

SELECT results.site,
       results.YEAR,
               results.MONTH,
                       sum(results.visits.estimatedValue) AS rvisits 
FROM analytics.snapshot_estimated_totals_incoming_keywords AS results
WHERE results.keywords="photo calendar"
  AND results.year=16
  AND (results.MONTH=9 or results.month=8)
  AND results.country=840
  group by results.site, results.year, results.month;

--Results:
-- quill.com	16	9	104.33158987616338

SELECT results.site,
       results.YEAR,
              results.MONTH,
                       results.keywords,
                       sum(results.visits.estimatedValue) AS rvisits
FROM analytics.snapshot_estimated_totals_incoming_keywords AS results
WHERE results.keywords like "%photo calendar%"
  AND results.year=16
  AND (results.month=8)
  AND results.country=840
  group by results.site, results.year, results.month, results.keywords;



--Results:
shutterfly.com	8393.31892375258
vistaprint.com	6417.047935097525
snapfish.com	4923.682439652249
photo.walgreens.com#	3278.341959301123
photo.walgreens.com	3186.9159926254797
minted.com	1433.6580051763767
groupon.com	893.1893838248295
photos3.walmart.com	563.449677147124
photos3.walmart.com#	547.5767559046101
mixbook.com	178.40330693161968







 --AND INSTR(site,'*')>0