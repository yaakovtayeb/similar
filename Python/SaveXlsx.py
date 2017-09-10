import xlsxwriter
import pandas
import datetime

filename = 'JohnLewisWeeklyDistro.tsv'
workbook = xlsxwriter.Workbook(filename)
worksheet1 = workbook.add_worksheet()
worksheet.set_column('A:A', 4.71)
worksheet.set_column('B:F', 31)
worksheet.set_column('H:H', 4.71)
format1 = workbook.add_format()
format1.set_bg_color("#008000")


# df = pd.DataFrame({'Data': [10, 20, 30, 20, 15, 30, 45]})


