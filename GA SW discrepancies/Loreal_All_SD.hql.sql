--Monthly:

DROP TABLE yaakovt.loreal3;

CREATE EXTERNAL TABLE IF NOT EXISTS yaakovt.loreal3 (
  site string, 
  country int,
  desktop_visits double, 
  mobile_visits double,
  all_visits double, 
  YEAR int, 
  MONTH int
  ) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' LOCATION '/user/yaakov.tayeb/loreal3/';

INSERT OVERWRITE TABLE yaakovt.loreal3
SELECT site,
       country,
       desktop_visits,
       mobile_visits,
       (desktop_visits+mobile_visits) AS all_visits,
       year,
       month
FROM analytics.snapshot_overall_traffic
WHERE site IN ('armanibeauty.fr*',
                 'biotherm.fr*',
                 'cadum.fr*',
                 'carita.fr*',
                 'clarisonic.fr*',
                 'decleor.fr*',
                 'essie.fr*',
                 'garnier.fr*',
                 'helenarubinstein.com*',
                 'itcosmetics.com*',
                 'kerastase.fr*',
                 'kiehls.fr*',
                 'lancome.fr*',
                 'laroche-posay.fr*',
                 'look.fr*',
                 'loreal-paris.fr*',
                 'lorealprofessionnel.fr*',
                 'mapeaumonageetmoi.fr*',
                 'matrix-france.fr*',
                 'maybelline.fr*',
                 'mennenfrance.fr*',
                 'mixa.fr*',
                 'mizani.fr*',
                 'narta.fr*',
                 'nyxcosmetics.fr*',
                 'redken.fr*',
                 'roger-gallet.com*',
                 'sanoflore.fr*',
                 'shuuemura.fr*',
                 'skinceuticals.fr*',
                 'thebodyshop.fr*',
                 'urbandecay.fr*',
                 'ushuaia-beaute.fr*',
                 'vichy.fr*',
                 'yslbeauty.fr*')
        AND country=250
        AND ((year=16
              AND month>=9)
             OR (year=17
                 AND month<=2));

INSERT INTO yaakovt.loreal3
SELECT site,
       country,
       desktop_visits,
       mobile_visits,
       (desktop_visits+mobile_visits) AS all_visits,
       year,
       month
FROM analytics.snapshot_overall_traffic
WHERE site IN ('armanibeauty.de*',
'biotherm.de*',
'carita.de*',
'clarisonic.de*',
'club.biotherm.de*',
'decleor.de*',
'dessangehairbeauty.de*',
'essie.de*',
'fragrances.viktor-rolf.com*',
'garnier.de*',
'helenarubinstein.com*',
'kerastase.de*',
'kiehls.de*',
'lancome.de*',
'larocheposay.de*',
'livemore.biotherm.de*',
'loreal-paris.de*',
'lorealprofessionnel.de*',
'maisonmargiela.com*',
'matrixhaircare.de*',
'maybelline.de*',
'menexpert.de*',
'nyxcosmetics.de*',
'redken.de*',
'roger-gallet.com*',
'skinceuticals.de*',
'thebodyshop.de*',
'urbandecay.de*',
'vichy.de*',
'yslbeauty.com*'
)
        AND country=276
        AND ((year=16
              AND month>=9)
             OR (year=17
                 AND month<=2));

INSERT INTO yaakovt.loreal3
SELECT site,
       country,
       desktop_visits,
       mobile_visits,
       (desktop_visits+mobile_visits) AS all_visits,
       year,
       month
FROM analytics.snapshot_overall_traffic
WHERE site IN ('armanibeauty.co.uk*',
'carita.co.uk*',
'clarisonic.co.uk*',
'decleor.co.uk*',
'essie.co.uk*',
'garnier.co.uk*',
'kerastase.co.uk*',
'kiehls.co.uk*',
'lancome.co.uk*',
'laroche-posay.co.uk*',
'loreal-paris.co.uk*',
'lorealprofessionnel.co.uk*',
'matrixhaircare.co.uk*',
'maybelline.co.uk*',
'mizani-uk.com*',
'nyxcosmetics.co.uk*',
'pureology.co.uk*',
'redken.co.uk*',
'roger-gallet.com*',
'shuuemura.co.uk*',
'skinceuticals.co.uk*',
'thebodyshop.com*',
'urbandecay.co.uk*',
'vichy.co.uk*',
'yslbeauty.co.uk*'
)
        AND country=826
        AND ((year=16
              AND month>=9)
             OR (year=17
                 AND month<=2));


INSERT INTO yaakovt.loreal3
SELECT site,
       country,
       desktop_visits,
       mobile_visits,
       (desktop_visits+mobile_visits) AS all_visits,
       year,
       month
FROM analytics.snapshot_overall_traffic
WHERE site IN ('baxterofcalifornia.com*',
'biotherm-usa.com*',
'carita-us.com*',
'carolsdaughter.com*',
'clarisonic.nl*',
'decleorusa.com*',
'dermablend.com*',
'essie.com*',
'garnierusa.com*',
'giorgioarmanibeauty-usa.com*',
'itcosmetics.com*',
'kerastase-usa.com*',
'kiehls.com*',
'lancome-usa.com*',
'laroche-posay.us*',
'lorealparisusa.com*',
'lorealprofessionnel.com*',
'matrix.com*',
'maybelline.com*',
'mgbeautysupply.com*',
'mizani.com*',
'nyxcosmetics.com*',
'pureology.com*',
'redken.com*',
'shuuemuraartofhair-usa.com*',
'shuuemura-usa.com*',
'skinceuticals.com*',
'softsheen-carson.com*',
'thebodyshop-usa.com*',
'urbandecay.com*',
'vichyusa.com*',
'yslbeautyus.com*'
)
        AND country=840
        AND ((year=16
              AND month>=9)
             OR (year=17
                 AND month<=2));

hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.loreal3;">/home/yaakov.tayeb/output/loreal3.tsv;
