DROP TABLE yaakovt.group_keywords_content;
Create EXTERNAL TABLE IF NOT EXISTS yaakovt.group_keywords_content(
word                    string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/group_keywords_content/';

MSCK REPAIR TABLE yaakovt.group_keywords_content;

DROP TABLE yaakovt.group_keywords_analysis;
Create EXTERNAL TABLE IF NOT EXISTS yaakovt.group_keywords_analysis(
site                    string,
country                 bigint,
referrer                int,
visits                  double,
year                    int,
month                   int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/group_keywords_analysis/';

set hivevar:qcountry = 840;
set hivevar:qmonth = 7;
set hivevar:qyear = 17;

INSERT OVERWRITE TABLE yaakovt.group_keywords_analysis
SELECT
    b.site,
    b.country,
    b.paid,
    b.visits / sum(b.visits) over () AS traffic_share,
    b.y,
    b.m
FROM
    (select a.site as site,
            a.country as country,
            a.paid as paid,
            sum(a.estvisits) as visits,
            a.year as y,
            a.month as m
    FROM
        (SELECT
                site,
                country,
                referrer.refFlag as paid,
                visits.estimatedvalue as estvisits,
                keywords,
                year,
                month
        FROM analytics.snapshot_estimated_totals_incoming_keywords
        WHERE
            INSTR(site, '*')=0 AND
            INSTR(site, '#')=0 AND
            country=${qcountry} AND
            year = ${qyear} AND
            month = ${qmonth}
        ) a
    WHERE a.keywords in (select word from yaakovt.group_keywords_content)
    group by a.site, a.country, a.paid, a.year, a.month
    ) b
WHERE b.paid = 0
ORDER BY traffic_share DESC;


INSERT OVERWRITE TABLE yaakovt.group_keywords_analysis
SELECT
        a.site,
        a.country,
        a.referrer.refFlag,
        sum(a.visits.estimatedvalue),
        17,
        7
FROM analytics.snapshot_estimated_totals_incoming_keywords as a
inner join yaakovt.group_keywords_content as b on (a.keywords = b.word)
WHERE
    INSTR(a.site,'*')>0 AND
    a.country=${qcountry} AND
    a.year = ${qyear} AND
    a.month = ${qmonth}
GROUP BY
    a.site,
    a.country,
    a.referrer.refFlag
ORDER by sum(a.visits.estimatedvalue) DESC;

 --AND INSTR(site,'*')>0