DROP TABLE yaakovt.oldnewmobile;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.oldnewmobile (
  site string,
  country int,
  estold double,
  estnew double,
  YEAR int,
  MONTH int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
  LINES TERMINATED BY '\n'
  LOCATION '/user/yaakov.tayeb/oldnewmobile/';


INSERT OVERWRITE TABLE yaakovt.oldnewmobile
SELECT old.site,
       old.country,
       sum(old.visits) as old_mobile,
       new.visits,
       old.year,
       old.month
FROM mobile_backup.daily_site_adjusted_estimations AS old
INNER JOIN meta_ls_main.snapshot_estimated_values AS new
ON (old.site = new.site AND old.country = new.country and old.year=new.year And old.month=new.month)
WHERE old.year>=16
and (
    (old.country=250 and old.site in ('garnier.fr*', 'laroche-posay.fr*'))
    OR (old.country=276 and old.site in ('garnier.de*', 'larocheposay.de*'))
    OR (old.country=643 and old.site in ('garnier.com.ru*', 'laroche-posay.ru*', 'loreal-paris.ru*'))
    OR (old.country=724 and old.site in ('garnier.es*', 'laroche-posay.es*'))
    OR (old.country=826 and old.site in ('garnier.co.uk*', 'lancome.co.uk*', 'loreal-paris.co.uk*'))
    )
group by old.site, old.country, new.visits, old.year, old.month;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.oldnewmobile;">/home/yaakov.tayeb/output/oldnewmobile.tsv;