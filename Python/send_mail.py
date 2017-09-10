import smtplib
import sys
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
from email.mime.text import MIMEText
from random import randint

def send_mail(subject, message_body='Please see attached', file_to_attach = None, server='mta01.sg.internal', send_from='Server-DoNotReplay@similarweb.com', send_to='yaakov.tayeb@similarweb.com'):
    msg = MIMEMultipart()
    msg['Subject'] = subject
    msg['From'] = send_from
    msg['To'] = send_to

    msg.attach(MIMEText(message_body))

    for f in file_to_attach or []:
        f.seek(0)
        attach_name = 'Attach_' + str(randint(0,100)) + '.tsv'
        msg.attach(MIMEApplication(f.read(), Name=attach_name))

    # Send the email via our own SMTP server.
    s = smtplib.SMTP('mta01.sg.internal')
    s.sendmail(send_from, send_to, msg.as_string())
    s.quit()

if __name__ == '__main__':
    p = str(sys.argv)
    # p[1] = email, p[2] = file, p3=subject, p4 = content
    send_mail(p[1], p[2], p[3], p[4])


    recipient = 'yaakov.tayeb@similarweb.com'
    file_to_attach = ['Reports.zip']
    subject = 'Report for TEST'
    message_body = 'Report attached.'
    try:
        send_mail(subject, message_body, file_to_attach, send_to=recipient)
    except smtplib.SMTPSenderRefused:
        print "Mailing Failed."