import pandas as pd
import xlsxwriter
import sys
import os

def addsheet(trafficsource, data):
    sheet = data[:][['site', 'weekbegins', trafficsource, 'visits', 'year']]
    sheet.sort_values(by=['site', 'year'], ascending=[True, False], inplace=True)
    sheet.drop('year', axis=1, inplace=True)
    sheet['visits']=sheet['visits']*sheet[trafficsource]
    return sheet

def create_front(workbook, fname):
    # Create Cover Page

    worksheet1 = workbook.add_worksheet('Report Details')
    # formating = workbook.add_format({'align' : 'vcenter'})

    format_top_border = workbook.add_format()
    format_top_border.set_pattern(1)
    format_top_border.set_bg_color('#2D3D53')

    format_white_cells = workbook.add_format()
    format_white_cells.set_pattern(1)
    format_white_cells.set_bg_color('#FFFFFF')

    format_line_border = workbook.add_format()
    format_line_border.set_top_color('#E7E6E6')

    format_outer_cells = workbook.add_format()
    format_outer_cells.set_pattern(1);
    format_outer_cells.set_bg_color('#E7E6E6')

    worksheet1.set_row(2,41)
    worksheet1.set_row(3,19)
    worksheet1.set_row(4,19)
    worksheet1.set_row(5,31)
    worksheet1.set_row(6,31)
    worksheet1.set_row(9,1)
    worksheet1.set_column('D:D',30)
    worksheet1.set_column('F:F',45)
    worksheet1.set_column('E:E',15)
    worksheet1.set_column('A:A',5)
    worksheet1.set_column('C:C',2)
    worksheet1.set_column('G:G',2)
    worksheet1.set_column('H:H',2)


    for k in range(8):
        worksheet1.write(chr(k+ord('A'))+'1','',format_top_border)
        for b in range(2,14):
            if (b == 6):
                if(k==0 or k==7):
                    continue
                worksheet1.write(chr(k+ord('A'))+str(b),'',format_outer_cells)
            elif(b==10):
                if(k==0 or k==7):
                    continue
                worksheet1.write(chr(k+ord('A'))+str(b),'',format_top_border)
            else:
                worksheet1.write(chr(k+ord('A'))+str(b),'',format_white_cells)

    for a in range(14,300):
        for b in range(26):
            worksheet1.write(chr(b+ord('A'))+str(a),'',format_outer_cells)
    for a in range(300):
        for b in range(8,300):
            worksheet1.write(a,b,'',format_outer_cells)

    format_Orange = workbook.add_format()
    format_Orange.set_font_color('#F09700')
    format_Orange.set_font_size(12)
    format_Orange.set_font_name('Trebuchet MS')
    worksheet1.write('B4','Custom Report',format_Orange)

    format_write = workbook.add_format({'align' : 'vcenter'})
    format_write_color = workbook.add_format({'align' : 'vcenter'})

    format_write_color.set_font_color('#595959')
    format_write_color.set_font_size(13)
    format_write_color.set_font_name('Trebuchet MS')
    format_write_color.set_pattern(1)
    format_write_color.set_bg_color('#E7E6E6')
    worksheet1.write('B6','Report Name:',format_write_color)
    worksheet1.write('F6',fname, format_write_color)
    format_write.set_font_color('#595959')
    format_write.set_font_size(13)
    format_write.set_font_name('Trebuchet MS')
    worksheet1.write('B7','Delivery Date:',format_write)
    worksheet1.write('F7',fname, format_write)

def create_source(workbook, source, data):
    tmpsheet = addsheet(source, data)
    worksheet = workbook.add_worksheet(source)
    format1 = workbook.add_format({'bg_color': '#4863A0', 'font_name': 'Trebuchet MS', 'font_size': 12, 'font_color': 'white', 'align': 'center'})
    format2 = workbook.add_format({'bg_color': '#D5DBDB', 'font_name': 'Trebuchet MS', 'font_size': 12})
    format3 = workbook.add_format({'bg_color': '#F8F9F9', 'font_name': 'Trebuchet MS', 'font_size': 12})
    worksheet.set_default_row(24)
    worksheet.set_column('A:A', 50)
    worksheet.set_column('B:D', 20)
    for col in range(0, len(tmpsheet.columns.values)):
        worksheet.write(0, col, tmpsheet.columns[col], format1)
    for row in range(0, tmpsheet.shape[0]):
        for col in range(0, tmpsheet.shape[1]):
            if row % 2 == 0:
                worksheet.write(row + 1, col, tmpsheet.iloc[row][col], format2)
            else:
                worksheet.write(row + 1, col, tmpsheet.iloc[row][col], format3)

def create_All(workbook, data):
    worksheet = workbook.add_worksheet("All")
    format1 = workbook.add_format({'bg_color': '#4863A0', 'font_name': 'Trebuchet MS', 'font_size': 12, 'font_color': 'white', 'align': 'center'})
    format2 = workbook.add_format({'bg_color': '#D5DBDB', 'font_name': 'Trebuchet MS', 'font_size': 12})
    format3 = workbook.add_format({'bg_color': '#F8F9F9', 'font_name': 'Trebuchet MS', 'font_size': 12})
    worksheet.set_default_row(24)
    worksheet.set_column('A:A', 50)
    worksheet.set_column('B:L', 20)
    for col in range(0, len(data.columns.values)):
        worksheet.write(0, col, data.columns[col], format1)
    for row in range(0, data.shape[0]):
        for col in range(0, data.shape[1]):
            if row % 2 == 0:
                worksheet.write(row + 1, col, data.iloc[row][col], format2)
            else:
                worksheet.write(row + 1, col, data.iloc[row][col], format3)

def main():
    p = sys.argv
    path = os.getcwd() + "\\"
    path = '/home/yaakov.tayeb/reports/reports/'
    filename = p[1]
    # filename = path + filename
    data = pd.read_csv(path + filename, sep="\t", header=0) #header is the line n or None
    data.columns = [x.lower() for x in data.columns] # turn headers to lower case
    data.columns = [x[x.find(".")+1:len(x)] for x in data.columns] #delete table name from column name
    data["year"] = [int(x[-2:]) for x in data["weekbegins"]]
    data["site"] = [(x[:-1]) for x in data["site"]]
    # print(data.columns.values)

    fname = filename.replace("tsv", "xlsx")
    workbook = xlsxwriter.Workbook(path + fname)
    create_front(workbook, fname)
    create_source(workbook, 'direct', data)
    create_source(workbook, 'displayads', data)
    create_source(workbook, 'mail', data)
    create_source(workbook, 'organic_search', data)
    create_source(workbook, 'paid_search', data)
    create_source(workbook, 'referrals', data)
    create_source(workbook, 'social', data)

    data.sort_values(by=['site', 'year'], ascending=[True, False], inplace=True)
    data.drop('year', axis=1, inplace=True)
    create_All(workbook, data)

    workbook.close()

if __name__ == '__main__':
    # print(os.getcwd())
    main()