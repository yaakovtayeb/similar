#!/bin/bash
/opt/anaconda/envs/mrp27/bin/python /home/yaakov.tayeb/reports/changeweeklydistroparam.py
echo "Found relevant dates - Finished"
source /similargroup/production/scripts/common.sh
setHiveJars /similargroup/production/analytics
hive -f /home/yaakov.tayeb/reports/weeklydistro_runner.hql
echo "New Distor table is ready on the HDFS - Finished"
filedate=$(date +%d%m%y)
hive -e "set hive.cli.print.header=true; SELECT * FROM yaakovt.JohnLewisWeeklyDistro;">/home/yaakov.tayeb/reports/reports/JohnLewisWeeklyDistro${filedate}.tsv;
echo "Save the table to file - Finished"
/opt/anaconda/envs/mrp27/bin/python /home/yaakov.tayeb/reports/designExcel.py JohnLewisWeeklyDistro${filedate}.tsv
/opt/anaconda/envs/mrp27/bin/python /home/yaakov.tayeb/reports/sendmail.py yaakov.tayeb@similarweb.com /home/yaakov.tayeb/reports/reports/JohnLewisWeeklyDistro${filedate}.xlsx Weekly*YoY*Traffic*Distribution*Report Have*a*good*day