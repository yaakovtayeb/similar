drop table yaakovt.persona4;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.persona4 (
user                    string,
year                    int,
month                   int,
facebooks               double,
facebookn               int,
facebookshares          int,
tumblrs                 double,
tumblrn                 int,
tumblrshares            int,
twitters                double,
twittern                double,
twittershares           int,
googles                 double,
googlen                 double,
googleshares            int,
pins                    double,
pinn                    int,
pinshares               int,
linkedins               double,
linkedinn               int,
linkedinshares          int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/traffic/persona4/';

INSERT OVERWRITE TABLE yaakovt.persona4
SELECT user,
       year,
       month,
       SUM(case when site = "facbook.com*" then timestamps[size(timestamps)-1]-timestamps[0] else 0 end),
       SUM(case when site = "facbook.com*" then 1 else 0 end),
       SUM(case when site = "facebook.com*" then (length(concat_ws("|", pages)) - length(regexp_replace(concat_ws("|", pages), '^(facebook.com/sharer.php)*', '')))/length('facebook.com/sharer.php') else 0 end),
       SUM(case when site = "tumblr.com*" then timestamps[size(timestamps)-1]-timestamps[0] else 0 end),
       SUM(case when site = "tumblr.com*" then 1 else 0 end),
       SUM(case when site = "tumblr.com*" then (length(concat_ws("|", pages)) - length(regexp_replace(concat_ws("|", pages), '^(tumblr.com/widgets/share/tool/preview?shareSource)*', '')))/length('tumblr.com/widgets/share/tool/preview?shareSource') else 0 end),
       SUM(case when site = "twitter.com*" then timestamps[size(timestamps)-1]-timestamps[0] else 0 end),
       SUM(case when site = "twitter.com*" then 1 else 0 end),
       SUM(case when site = "twitter.com*" then (length(concat_ws("|", pages)) - length(regexp_replace(concat_ws("|", pages), '^(twitter.com/intent/tweet?original_referer)*', '')))/length('twitter.com/intent/tweet?original_referer') else 0 end),
       SUM(case when site = "plus.google.com#" then timestamps[size(timestamps)-1]-timestamps[0] else 0 end),
       SUM(case when site = "plus.google.com#" then 1 else 0 end),
       SUM(case when site = "plus.google.com#" then (length(concat_ws("|", pages)) - length(regexp_replace(concat_ws("|", pages), '^(plus.google.com/up/accounts/upgrade/?continue=https://plus.google.com/share?)*', '')))/length('plus.google.com/up/accounts/upgrade/?continue=https://plus.google.com/share?') else 0 end),
       SUM(case when site = "pinterest.com*" then timestamps[size(timestamps)-1]-timestamps[0] else 0 end),
       SUM(case when site = "pinterest.com*" then 1 else 0 end),
       SUM(case when site = "pinterest.com*" then (length(concat_ws("|", pages)) - length(regexp_replace(concat_ws("|", pages), '^(pinterest.com/pin/create/bookmarklet)*', '')))/length('pinterest.com/pin/create/bookmarklet') else 0 end),
       SUM(case when site = "linkedin.com*" then timestamps[size(timestamps)-1]-timestamps[0] else 0 end),
       SUM(case when site = "linkedin.com*" then 1 else 0 end),
       SUM(case when site = "linkedin.com*" then (length(concat_ws("|", pages)) - length(regexp_replace(concat_ws("|", pages), '^(linkedin.com/shareArticle)*', '')))/length('linkedin.com/shareArticle') else 0 end)
FROM ds.parquet_visits
WHERE year=17 and (month>=5 and month<=7) and country=840
GROUP BY user, year, month;

drop table yaakovt.persona1;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.persona1 (
user                    string,
year                    int,
month                   int,
socialbeast             int default 0
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/traffic/persona1/';

INSERT OVERWRITE TABLE yaakovt.persona1
SELECT b.user, b.year, b.month, a.


hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.visits;">/home/yaakov.tayeb/output/skybet.tsv;

select regexp_replace('tryplaythisplay', '^(play)([a-z0-9]+)$', '');


-- select (length('playthisthis') - length(regexp_replace('playplaythisthis', '^(play)*', ''))) / length('play');

SUM(case when site = "facebook.com*" then (length(concat_ws("|", pages)) - length(regexp_replace(concat_ws("|", pages), '^(facebook.com/sharer.php)*', '')))/length('facebook.com/sharer.php') else 0 end),

drop table yaakovt.persona2;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.persona2 (
user                    string,
facebookshares          int,
tumblrshares            int,
twittershares           int,
googleshares            int,
pinshares               int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/traffic/persona2/';

INSERT OVERWRITE TABLE yaakovt.persona2
select exploded.USER,
       SUM(if(exploded.page like "%facebook.com/sharer.php%", 1,0)),
       SUM(if(exploded.page like "%tumblr.com/widgets/share/tool/preview?shareSource%", 1,0)),
       SUM(if(exploded.page like "%twitter.com/intent/tweet?original_referer%", 1,0)),
       SUM(if(exploded.page like "%plus.google.com/up/accounts/upgrade/?continue=https://plus.google.com/share?%", 1,0)),
       SUM(if(exploded.page like "%pinterest.com/pin/create/bookmarklet%", 1,0))
FROM (select user,page from ds.parquet_visits  LATERAL VIEW explode(pages) pages AS page where year=17 and month=07 and country=840) exploded
group by user;

select user, facebookshares+tumblrshares+twittershares+googleshares+pinshares as beasts from yaakovt.persona1 where facebookshares+tumblrshares+twittershares+googleshares+pinshares>1;







select v.user, p from
(select user, pages from ds.parquet_visits limit 6) v
LATERAL VIEW EXPLODE(v.pages) as p;


select user,page from ds.parquet_visits  LATERAL VIEW
explode(pages) pages AS page where year=17 and month=07  and country=840


SELECT pageid, adid
FROM pageAds LATERAL VIEW explode(adid_list) adTable AS adid;