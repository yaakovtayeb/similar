--CREATE TABLES FOR COUNTRIES NAMES AND FILTERS
--AND TWO MORE FOR EST RESULTS PER MONTH
-- SET mapred.job.queue.name = root.research_shared;

drop table yaakovt.countriesCodes;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.countriesCodes(
countryCode     int,
countryName     string,
DesktopFilter   int,
MobileFilter    int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/countriesCode';

drop table yaakovt.desktop_estimationAcc;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.desktop_estimationAcc(
country         double,
type            string,
error           double,
sitesize        double,
nlearningsets   double,
swSitesInRange  double,
Acc             double
)
PARTITIONED BY (platfrom string, test string, year INT, month INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/similargroup/data/analytics/snapshot/accuracy_tests';

drop table yaakovt.mobile_estimationAcc;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.mobile_estimationAcc(
country         double,
type            string,
error           double,
sitesize        double,
nlearningsets   double,
swSitesInRange  double,
Acc             double
)
PARTITIONED BY (platfrom string, test string, year INT, month INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/similargroup/data/mobile-analytics/snapshot/accuracy_tests';

drop table yaakovt.accuracyReport;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.accuracyReport(
country     string,
platform    string,
sitesize    double,
LB          double,
C           double,
UB          double,
month       int,
year        int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/accuracyReport';

-- ONLY RUN FROM HERE


MSCK REPAIR TABLE yaakovt.mobile_estimationAcc;
MSCK REPAIR TABLE yaakovt.desktop_estimationAcc;

set hivevar:desktop_md_acc = 0.75;
set hivevar:desktop_count = 533;
set hivevar:desktop_dm_std=0.01875586212;
set hivevar:desktop_upper=0.8062675864;
set hivevar:desktop_lower=0.6937324136;
set hivevar:mobile_md_acc = 0.7;
set hivevar:mobile_count = 533;
set hivevar:mobile_dm_std= 0.01984933872;
set hivevar:mobile_upper = 0.7595480162;
set hivevar:mobile_lower = 0.6404519838;
set hivevar:year = 17;
set hivevar:month = 6;

INSERT OVERWRITE TABLE yaakovt.accuracyReport
SELECT  a.countryName,
        'Desktop',
        b.sitesize,
        case
            when (b.Acc/${desktop_upper})>0.87 then 0.87
            else (b.Acc/${desktop_upper})
        end  as LB,
        case
            when (b.Acc/${desktop_upper})>0.9 then 0.9
            else (b.Acc/${desktop_md_acc})
        end  as C,
        case
            when (b.Acc/${desktop_lower})>0.93 then 0.93
            else (b.Acc/${desktop_lower})
        end  as UB,
        ${month},
        ${year}
FROM yaakovt.desktop_estimationAcc AS b
inner join yaakovt.countriesCodes as a ON (a.countryCode=b.country)
WHERE b.Acc>0 and b.error=0.3 and b.platfrom="desktop" and test="accuracy" and b.year=${year} and b.month=${month} and a.DesktopFilter=1;

INSERT INTO yaakovt.accuracyReport
SELECT  a.countryName,
        'Mobile',
        c.sitesize,
        case
            when (c.Acc/${mobile_upper})>0.87 then 0.87
            else (c.Acc/${mobile_upper})
        end  as LB,
        case
            when (c.Acc/${mobile_upper})>0.9 then 0.9
            else (c.Acc/${mobile_md_acc})
        end  as C,
        case
            when (c.Acc/${mobile_lower})>0.93 then 0.93
            else (c.Acc/${mobile_lower})
        end  as UB,
        ${month},
        ${year}
FROM yaakovt.mobile_estimationAcc AS c
inner join yaakovt.countriesCodes as a ON (a.countryCode=c.country)
WHERE c.Acc>0 and c.error=0.3 and c.platfrom="mw" and c.test="accuracy" and c.year=${year} and c.month=${month} and a.MobileFilter=1;;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.accuracyReport;">/home/yaakov.tayeb/output/AccReport1708.tsv;

-- select C from yaakovt.accuracyreport where year=17 and month=5 and country="US" and sitesize=1000000 and platform="desktop";