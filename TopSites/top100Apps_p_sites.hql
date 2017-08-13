drop table yaakovt.top100_website_traffic_Nigeria;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.top100_website_traffic_Nigeria (
   site string, 
   country int, 
   desktop_visits double
   ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/outputs/traffic/top100_website_traffic_Nigeria/';


INSERT overwrite TABLE yaakovt.top100_website_traffic_Nigeria
SELECT b.site,
       b.country,
       b.desktop_visits
FROM analytics.snapshot_overall_traffic AS b
WHERE country=566
        AND YEAR=16
        AND MONTH=9
        AND instr(site, "*")>0
ORDER BY b.desktop_visits DESC LIMIT 120;

INSERT INTO yaakovt.top100_website_traffic_Nigeria
SELECT b.site,
       b.country,
       b.desktop_visits
FROM analytics.snapshot_overall_traffic AS b
WHERE country=566
        AND YEAR=16
        AND MONTH=10
        AND instr(site, "*")>0
ORDER BY b.desktop_visits DESC LIMIT 120;

INSERT INTO yaakovt.top100_website_traffic_Nigeria
SELECT b.site,
       b.country,
       b.desktop_visits
FROM analytics.snapshot_overall_traffic AS b
WHERE country=566
        AND YEAR=16
        AND MONTH=11
        AND instr(site, "*")>0
ORDER BY b.desktop_visits DESC LIMIT 120;

INSERT INTO yaakovt.top100_website_traffic_Nigeria
SELECT b.site,
       b.country,
       b.desktop_visits
FROM analytics.snapshot_overall_traffic AS b
WHERE country=566
        AND YEAR=16
        AND MONTH=12
        AND instr(site, "*")>0
ORDER BY b.desktop_visits DESC LIMIT 120;

INSERT INTO yaakovt.top100_website_traffic_Nigeria
SELECT b.site,
       b.country,
       b.desktop_visits
FROM analytics.snapshot_overall_traffic AS b
WHERE country=566
        AND YEAR=17
        AND MONTH=1
        AND instr(site, "*")>0
ORDER BY b.desktop_visits DESC LIMIT 120;

INSERT INTO yaakovt.top100_website_traffic_Nigeria
SELECT b.site,
       b.country,
       b.desktop_visits
FROM analytics.snapshot_overall_traffic AS b
WHERE country=566
        AND YEAR=17
        AND MONTH=2
        AND instr(site, "*")>0
ORDER BY b.desktop_visits DESC LIMIT 120;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.top100_website_traffic_Nigeria;">/home/yaakov.tayeb/output/top100_website_traffic_Nigeria.tsv;

-- APPS:

drop table yaakovt.top100_apps_currentinstalls_Nigeria;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.top100_apps_currentinstalls_Nigeria (
   app string, 
   country int, 
   month int,
   year int,
   reach double
   ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION 
'/user/yaakov.tayeb/outputs/traffic/top100_apps_currentinstalls_Nigeria/';


--9
INSERT overwrite TABLE yaakovt.top100_apps_currentinstalls_Nigeria2
SELECT a.app,
       a.country,
       a.MONTH,
       a.YEAR,
       avg(a.reach) AS m_reach,
       b.maincategory
FROM mobile.daily_app_engagement_estimations as a
INNER JOIN mobile.app_info AS b ON (a.app=b.id
                                    AND a.month=b.month
                                    AND a.year=b.year)
WHERE b.day=1
  AND a.country=566
  AND a.YEAR=16
  AND a.MONTH=9
  AND a.app IN (SELECT app FROM mobile.user_apps WHERE YEAR=16 AND MONTH=9)
     GROUP BY app)
GROUP BY a.app,
         a.country,
         a.MONTH,
           a.YEAR, 
           b.maincategory
ORDER BY m_reach DESC LIMIT 100;

--10
INSERT INTO yaakovt.top100_apps_currentinstalls_Nigeria2
SELECT a.app,
       a.country,
       a.MONTH,
       a.YEAR,
       avg(a.reach) AS m_reach,
       b.maincategory
FROM mobile.daily_app_engagement_estimations as a
INNER JOIN mobile.app_info AS b ON (a.app=b.id
                                    AND a.month=b.month
                                    AND a.year=b.year)
WHERE b.day=1
  AND a.country=566
  AND a.YEAR=16
  AND a.MONTH=10
  AND a.app IN (SELECT app FROM mobile.user_apps WHERE YEAR=16 AND MONTH=10
     GROUP BY app)
GROUP BY a.app,
         a.country,
         a.MONTH,
           a.YEAR, 
           b.maincategory
ORDER BY m_reach DESC LIMIT 100;

--11
INSERT INTO yaakovt.top100_apps_currentinstalls_Nigeria2
SELECT a.app,
       a.country,
       a.MONTH,
       a.YEAR,
       avg(a.reach) AS m_reach,
       b.maincategory
FROM mobile.daily_app_engagement_estimations as a
INNER JOIN mobile.app_info AS b ON (a.app=b.id
                                    AND a.month=b.month
                                    AND a.year=b.year)
WHERE b.day=1
  AND a.country=566
  AND a.YEAR=16
  AND a.MONTH=11
  AND a.app IN (SELECT app FROM mobile.user_apps WHERE YEAR=16 AND MONTH=11
     GROUP BY app)
GROUP BY a.app,
         a.country,
         a.MONTH,
           a.YEAR, 
           b.maincategory
ORDER BY m_reach DESC LIMIT 100;

--12
INSERT INTO yaakovt.top100_apps_currentinstalls_Nigeria2
SELECT a.app,
       a.country,
       a.MONTH,
       a.YEAR,
       avg(a.reach) AS m_reach,
       b.maincategory
FROM mobile.daily_app_engagement_estimations as a
INNER JOIN mobile.app_info AS b ON (a.app=b.id
                                    AND a.month=b.month
                                    AND a.year=b.year)
WHERE b.day=1
  AND a.country=566
  AND a.YEAR=16
  AND a.MONTH=12
  AND a.app IN (SELECT app FROM mobile.user_apps WHERE YEAR=16 AND MONTH=12
     GROUP BY app)
GROUP BY a.app,
         a.country,
         a.MONTH,
           a.YEAR, 
           b.maincategory
ORDER BY m_reach DESC LIMIT 100;

--1
INSERT INTO yaakovt.top100_apps_currentinstalls_Nigeria2
SELECT a.app,
       a.country,
       a.MONTH,
       a.YEAR,
       avg(a.reach) AS m_reach,
       b.maincategory
FROM mobile.daily_app_engagement_estimations as a
INNER JOIN mobile.app_info AS b ON (a.app=b.id
                                    AND a.month=b.month
                                    AND a.year=b.year)
WHERE b.day=1
  AND a.country=566
  AND a.YEAR=17
  AND a.MONTH=1
  AND a.app IN (SELECT app FROM mobile.user_apps WHERE YEAR=17 AND MONTH=1
     GROUP BY app)
GROUP BY a.app,
         a.country,
         a.MONTH,
           a.YEAR, 
           b.maincategory
ORDER BY m_reach DESC LIMIT 100;

--2
INSERT INTO yaakovt.top100_apps_currentinstalls_Nigeria2
SELECT a.app,
       a.country,
       a.MONTH,
       a.YEAR,
       avg(a.reach) AS m_reach,
       b.maincategory
FROM mobile.daily_app_engagement_estimations as a
INNER JOIN mobile.app_info AS b ON (a.app=b.id
                                    AND a.month=b.month
                                    AND a.year=b.year)
WHERE b.day=1
  AND a.country=566
  AND a.YEAR=17
  AND a.MONTH=2
  AND a.app IN (SELECT app FROM mobile.user_apps WHERE YEAR=17 AND MONTH=2
     GROUP BY app)
GROUP BY a.app,
         a.country,
         a.MONTH,
           a.YEAR, 
           b.maincategory
ORDER BY m_reach DESC LIMIT 100;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.top100_apps_currentinstalls_Nigeria2;">/home/yaakov.tayeb/output/top100_apps_currentinstalls_Nigeria.tsv;
hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.top100_website_traffic_Nigeria2;">/home/yaakov.tayeb/output/top100_website_traffic_Nigeria.tsv;