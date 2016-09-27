import smtplib
import sys
import ConfigParser
from email.mime.text import MIMEText
from email.header import Header

config = ConfigParser.ConfigParser()
config.readfp(open('mail.cfg'))

mailServer = config.get("Email","mailServer")
sender = config.get("Email", "sender")
senderShow = config.get("Email", "senderShow")
ccList = config.get("Email", "ccList")
mailHeader = config.get("Email", "mailHeader")
mailFooter = config.get("Email", "mailFooter")

header = "<h3>Hi all<font color='#FF0000'></font>,</h3><br/>"
receiver = 'zhongshan@le.com'
subject = '[Timely Build]  Build Error on branch'

content = header + mailHeader + sys.argv[2] + mailFooter

msg = MIMEText(content,'html',_charset='utf-8')
msg['From'] = senderShow
msg['To']   = 'zhongshan@le.com'
msg['Subject'] = Header(subject, 'utf-8')
smtp = smtplib.SMTP(mailServer)
smtp.sendmail(sender, receiver, msg.as_string())
smtp.quit()

