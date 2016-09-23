import smtplib
from email.mime.text import MIMEText
from email.header import Header

def sendEmail():
    header = "<h3>Hi <font color='#FF0000'>xxx</font>,</h3><br/>"
    sender = 'autobuildsystem@letv.com'
    receiver = 'zhongshan@le.com'
    subject = '[Timely Build]  Build Error on branch'
    smtpserver = 'mail.letv.com'

    msg = MIMEText(header,'html',_charset='utf-8')
    msg['From'] = sender
    msg['To']   = 'zhongshan@le.com'
    msg['Subject'] = Header(subject, 'utf-8')
    smtp = smtplib.SMTP(smtpserver)
    smtp.sendmail(sender, receiver, msg.as_string())
    smtp.quit()

if __name__ == "__main__":
    sendEmail()
