import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

fileToSend = "Plots2.py"
username = "yaakov.tayeb@similarweb.com"
password = "SimGlobal1#"

username = "yaakovtayeb@gmail.com"
password = "91121820"

site = "http://ynet.co.il"
msgtext = "Attached below Weekly Traffic Sources for the site: %s" % site
msg = MIMEMultipart('alternative')
msg.attach(MIMEText(msgtext, 'plain'))

msg['Subject'] = "Weekly Traffic Sources"
msg['From'] = "yaakov.tayeb@similarweb.com"
msg['To'] = "yaakov.tayeb@similarweb.com"
msg.preamble = msg['Subject']

fp = open(fileToSend)
attachment = MIMEText(fp.read())
fp.close()

attachment.add_header("Content-Disposition", "attachment", filename=fileToSend)
msg.attach(attachment)

server = smtplib.SMTP("smtp.gmail.com:587")
server.starttls()
server.login(username, password)
server.sendmail(msg['From'], msg['To'], msg.as_string())
server.quit()

