drop table yaakovt.popularpages;
CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.popularpages (
site                    string,
site2                   string,
source                  string,
country                 int,
refpath                 array<string>,
pages                   array<string>,
user                    string,
year                    int,
month                   int,
day                     int,
device                  string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n' 
LOCATION '/user/yaakov.tayeb/outputs/traffic/popularpages/';

--INSERT INTO yaakovt.find_in_visits
INSERT OVERWRITE TABLE yaakovt.popularpages
SELECT site,
       site2,
       source,
       country,
       refpath,
       pages,
       user,
       YEAR,
       MONTH,
       DAY,
       'Mobile'
FROM ds.parquet_visits
WHERE site="hurleyburley.com*"
and year=17 and  country<999 and month=7
order by month, day;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.popularpages;">/home/yaakov.tayeb/output/totaljobs5.tsv;

INSERT INTO yaakovt.popularpages
INSERT OVERWRITE TABLE yaakovt.popularpages
SELECT site,
       site2,
       source,
       country,
       refpath,
       pages,
       user,
       YEAR,
       MONTH,
       DAY,
       'mobile'
FROM ds.parquet_visits_mobile
WHERE (source in ('5025', '5267', '990', '870', '991', '874', '875', '876', '877', '878', '879', '5139', '5019', '5415', '4068', '883', '886', '887',
                 '889', '5149', '5424', '5304', '5288', '5048', '5202', '5160', '890', '650', '651', '652', '894', '653', '654', '896', '655', '897',
                 '656', '657', '899', '658', '5039', '5174', '5177', '5179', '5059', '5220', '5067', '5180', '950', '951', '955', '957', '958', '959',
                 '5197', '5475', '5477', '5072', '960', '961', '963', '966', '969', '5240', '5482', '5087', '5120', '5121', '5003', '5125', '5488', '5084',
                  '971', '972', '976', '977', '978', '858', '979', '859', '5119', '5130', '5010', '5134', '5497', '980', '860', '981', '982', '983', '984',
                  '864', '985', '986', '866', '5126', '5401', '988', '868', '989', '869', '902', '5129', '903', '904', '905')
or (country=156 and source in ('5266', '5031', '5274', '5027', '5042', '5044', '5045', '5172', '5203', '5063', '5232', '5079', '5251', '5090')) or (country=392 and source='5432')
or (country=410 and source='5476') or (country != 156 and source='952') or (country in (156, 344, 158) and source = '5136'))
AND site="movistar.cl*" and year=17 and  country<999 and month=8;

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.popularpages;">/home/yaakov.tayeb/output/movistar.com.tsv;