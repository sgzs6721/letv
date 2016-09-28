import smtplib
import sys
import re
from pprint import pprint
import ConfigParser
from email.mime.text import MIMEText
from email.header import Header

def getErrorInfo(csvFile) :
    info = []
    for line in open(csvFile):
        if re.match(r"^\s+$",line) :
            continue
        if re.match(r"ERROR FILLE,",line):
            continue
        else:
           info.append(line.split(", ",11))
    pprint(info)
    return info

def sendMail(mailConf, mailInfo) :
    config = ConfigParser.ConfigParser()
    config.readfp(open(mailConf))

    mailServer = config.get("Email","mailServer")
    sender = config.get("Email", "sender")
    senderShow = config.get("Email", "senderShow")
    ccList = config.get("Email", "ccList")
    mailHeader = config.get("Email", "mailHeader")
    mailFooter = config.get("Email", "mailFooter")

    header = "<h3>Hi all<font color='#FF0000'></font>,</h3><br/>"
    receiver = 'zhongshan@le.com'
    subject = '[Timely Build]  Build Error on branch'

    content = getMailContent()
    msg = MIMEText(content,'html',_charset='utf-8')
    msg['From'] = senderShow
    msg['To']   = 'zhongshan@le.com'
    msg['Subject'] = Header(subject, 'utf-8')
    smtp = smtplib.SMTP(mailServer)
    smtp.sendmail(sender, receiver, msg.as_string())
    smtp.quit()

def getMailContent():
    print "1"

errorInfo = getErrorInfo(sys.argv[1])
#buildInfo = getBuildInfo(sys.argv[2])
#sendMail("mail.cfg", mailInfo)
