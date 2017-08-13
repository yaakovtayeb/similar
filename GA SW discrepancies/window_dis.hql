

DROP TABLE yaakovt.window_data;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.window_data (
  site           string,
  country        int,
  mobile_visits  double,
  desktop_visits double,
  direct         double,
  mail           double,
  referrals      double,
  social         double,
  organic        double,
  paid           double,
  display        double,
  YEAR           int,
  MONTH          int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
  LINES TERMINATED BY '\n'
  LOCATION '/user/yaakov.tayeb/window_data/';

--Desktop

set hivevar:qsite = 'compado.de*';
-- mobile table here is for Ww data only. use mobile.daily_site_adjusted_estimations for country not 999
set hivevar:qcountry = 999;
set hivevar:qmonth = 7;
set hivevar:qyear = 17;

INSERT OVERWRITE TABLE yaakovt.window_data
SELECT d.site,
       d.country,
       sum(m.mobile_visits),
       sum(d.visits),
       sum(case when getTopSpecialReferrerUDF(d.refid) = 5 then d.visits else 0 end) AS direct,
       sum(case when getTopSpecialReferrerUDF(d.refid) = 3 then d.visits else 0 end) AS mail,
       sum(case when getTopSpecialReferrerUDF(d.refid) = 6 then d.visits else 0 end) AS referrals,
       sum(case when getTopSpecialReferrerUDF(d.refid) = 2 then d.visits else 0 end) AS social,
       sum(case when getTopSpecialReferrerUDF(d.refid) = 1 and d.refflag=0 then d.visits else 0 end) AS organic,
       sum(case when getTopSpecialReferrerUDF(d.refid) = 1 and d.refflag=1 then d.visits else 0 end) AS paid,
       sum(case when getTopSpecialReferrerUDF(d.refid) = 4 then d.visits else 0 end) AS display,
       d.year,
       d.month
FROM analytics.daily_estimated_totals_sr as d inner join (Select site, month, year, sum(visits) as mobile_visits from mobile.daily_site_ww_adjusted_estimations WHERE site=${qsite} and year=${qyear} and month=${qmonth} and country=${qcountry} group by month, year, site) m
ON (m.site=d.site and m.year=d.year and m.month=d.month)
group by d.site, d.country, m.mobile_visits, d.year, d.month;


hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.monthly_data;">/home/yaakov.tayeb/output/data.tsv;

hive -e "set hive.cli.print.header=true; SELECT landingpage FROM ds.parquet_visits where month=7 and year=17 and site='compado.de*' and country<999;">/home/yaakov.tayeb/output/compado.de_params.tsv;