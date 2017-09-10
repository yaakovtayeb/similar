import smtplib
import sys
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
from email.mime.text import MIMEText
import os

def send_mail(recipient = 'yaakov.tayeb@similarweb.com', file = None, subject='', message_body='Please see attached'):
    path = os.getcwd() + "\\"
    print("path: %s" % path)

    server = 'mta01.sg.internal'

    msg = MIMEMultipart()
    msg['Subject'] = subject.replace("*", " ")
    msg['From'] = 'Server-DoNotReply@similarweb.com'
    msg['To'] = recipient

    if file is not None:
        msg.attach(MIMEText(message_body.replace("*", " ")))
        part = MIMEApplication(open(file, 'rb').read())
        filename = file[file.rfind('/')+1:len(file)]
        attachtxt = "attachment; filename=%s" % filename
        part['Content-Disposition'] = attachtxt
        msg.attach(part)

    # Send the email via our own SMTP server.
    s = smtplib.SMTP(server)
    s.set_debuglevel(1)
    s.sendmail(msg['From'], recipient, msg.as_string())
    s.quit()


def main():
    p = sys.argv
    print p
    # p[1] = sendtoemail, p[2] = files array, p3=subject, p4 = content
    try:
        send_mail(p[1], p[2], p[3], p[4])
    except smtplib.SMTPSenderRefused:
        print "Mailing Failed."

if __name__ == '__main__':
    main()