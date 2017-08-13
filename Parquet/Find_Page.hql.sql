--Find something in the Parquet

SELECT * FROM ds.parquet_visits WHERE site="abrst.pro" AND year=17 and month=2 and day=7;
SELECT concat_ws(',', ) FROM ds.parquet_visits WHERE site="abrst.pro" AND year=17 and month=2 and day=7;



SELECT a.pages_list
FROM
        (SELECT concat_ws(',', pages) AS pages_list
         FROM ds.parquet_visits
         WHERE site="abrst.pro"
                 AND YEAR=17
                 AND MONTH=2
                 AND DAY=7) a
WHERE a.pages_list LIKE "%abrst.pro/preview/%";