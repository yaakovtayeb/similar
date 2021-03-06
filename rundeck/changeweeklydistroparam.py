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


def main():
    year, week, _ = datetime.datetime.now().isocalendar()
    this_sat = iso_to_gregorian(year, week, 6)
    this_sun = iso_to_gregorian(year, week, 0)
    last_year_sat = iso_to_gregorian(year - 1, week, 6)
    last_year_sun = iso_to_gregorian(year - 1, week, 0)
    sat_2y = iso_to_gregorian(year - 2, week, 6)
    sun_2y = iso_to_gregorian(year - 2, week, 0)

    weekbegins = this_sun.strftime('%m.%d.%Y')
    weekends = this_sat.strftime('%m.%d.%Y')
    lyweekbegins = last_year_sun.strftime('%m.%d.%Y')
    lyweekends = last_year_sat.strftime('%m.%d.%Y')
    weekbegins_2y = sun_2y.strftime('%m.%d.%Y')
    weekends_2y = sat_2y.strftime('%m.%d.%Y')

    day1 = this_sun.day
    day2 = this_sat.day
    month1 = this_sun.month
    month2 = this_sat.month
    year = this_sun.year-2000
    lyday1 = last_year_sun.day
    lymonth1 = last_year_sun.month
    lyday2 = last_year_sat.day
    lymonth2 = last_year_sat.month
    ly = this_sun.year-2000-1
    day1_2y = sun_2y.day
    month1_2y = sun_2y.month
    day2_2y = sat_2y.day
    month2_2y = sat_2y.month
    minus2y = this_sun.year-2000-2


    tf = []
    # path of the file on the docker folder tree
    with open('/home/yaakov.tayeb/reports/weeklydistro.hql') as f:
        lines = f.readlines()

    for line in lines:
        line = line.replace("q1", weekbegins)
        line = line.replace("q2", weekends)
        line = line.replace("q3", lyweekbegins)
        line = line.replace("q4", lyweekends)
        line = line.replace("q5", str(day1))
        line = line.replace("q6", str(day2))
        line = line.replace("q7", str(month1))
        line = line.replace("q8", str(month2))
        line = line.replace("q9", str(year))
        line = line.replace("qa10", str(lyday1))
        line = line.replace("qa11", str(lymonth1))
        line = line.replace("qa12", str(lyday2))
        line = line.replace("qa13", str(lymonth2))
        line = line.replace("qa14", str(ly))
        line = line.replace("qa15", weekbegins_2y)
        line = line.replace("qa16", weekends_2y)
        line = line.replace("qa17", str(day1_2y))
        line = line.replace("qa18", str(month1_2y))
        line = line.replace("qa19", str(day2_2y))
        line = line.replace("qa20", str(month2_2y))
        line = line.replace("qa21", str(minus2y))
        tf.append(line)

    f = open('/home/yaakov.tayeb/reports/weeklydistro_runner.hql', 'w')
    for i in tf:
        f.write(i)
    f.close()

if __name__ == '__main__':
    main()