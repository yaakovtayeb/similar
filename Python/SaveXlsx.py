import xlsxwriter
import pandas
import datetime

def iso_year_start(iso_year):
    "The gregorian calendar date of the first day of the given ISO year"
    fourth_jan = datetime.date(iso_year, 1, 4)
    delta = datetime.timedelta(fourth_jan.isoweekday()-1)
    return fourth_jan - delta

def iso_to_gregorian(iso_year, iso_week, iso_day):
    "Gregorian calendar date for the given ISO year, week and day"
    year_start = iso_year_start(iso_year)
    return year_start + datetime.timedelta(days=iso_day-1, weeks=iso_week-1)

year, week, _ = datetime.datetime.now().isocalendar()
this_sunday = iso_to_gregorian(year, week, 0)
this_monday = iso_to_gregorian(year, week-1, 1)
last_year_sunday = iso_to_gregorian(year - 1, week, 0)
last_year_monday = iso_to_gregorian(year - 1, week-1, 1)




filedate = this_sunday.strftime('%m/%d/%Y')
filename = 'Weekly Traffic Sources - %s.xlsx' % filedate
workbook = xlsxwriter.Workbook(filename)
worksheet1 = workbook.add_worksheet()
worksheet.set_column('A:A', 4.71)
worksheet.set_column('B:F', 31)
worksheet.set_column('H:H', 4.71)
format1 = workbook.add_format()
format1.set_bg_color("#008000")






df = pd.DataFrame({'Data': [10, 20, 30, 20, 15, 30, 45]})


