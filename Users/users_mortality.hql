drop table yaakovt.users_mortality;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.users_mortality (
user                    string,
country                 int,
rawvisits               int,
month                   int,
year                    int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '/user/yaakov.tayeb/outputs/traffic/users_mortality/';

INSERT OVERWRITE TABLE yaakovt.users_mortality
SELECT
    user,
    country,
    sum(1) as rawvisits,
    month,
    year
FROM ds.parquet_visits WHERE year=17
group by user, country, month, year;

hive -e "set hive.cli.print.header=true;
select
    USER,
    sum(if(month=1,rawvisits,0)) as January,
    sum(if(month=2,rawvisits,0)) as February,
    sum(if(month=3,rawvisits,0)) as March,
    sum(if(month=4,rawvisits,0)) as April,
    sum(if(month=5,rawvisits,0)) as May,
    sum(if(month=6,rawvisits,0)) as June,
    sum(if(month=7,rawvisits,0)) as July,
    sum(if(month=8,rawvisits,0)) as August
FROM yaakovt.users_mortality
WHERE country<999 group by user;" >/home/yaakov.tayeb/output/mortality.tsv;

