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

    receiver = 'zhongshan@le.com'
    subject = '[Build Error] Please help to check the build error as following'

    content = getMailContent(mailInfo)
    msg = MIMEText(mailHeader + content[0] + mailFooter,'html',_charset='utf-8')
    msg['From'] = senderShow
    msg['To']   = 'zhongshan@le.com'
    msg['Subject'] = Header(subject, 'utf-8')
    smtp = smtplib.SMTP(mailServer)
    smtp.sendmail(sender, receiver, msg.as_string())
    smtp.quit()

def getMailContent(errorInfo):
    content = ""
    mailList = []
    for error in errorInfo :
        content = content + "<table border='1' cellspacing='0px'><tr><td bgcolor='#00FF00'>File</td><td>" + error[0] + "</td></tr>"
        content = content + "<tr><td bgcolor='#00FF00'>LogNo.</td><td>" + error[1] + "</td></tr>"
        content = content + "<tr><td bgcolor='#00FF00'>Line</td><td>" + error[2] + "</td></tr>"
        content = content + "<tr><td bgcolor='#00FF00'>Owner</td><td><font color='#FF0000'><strong>" + error[3] + "</strong></font></td></tr>"
        content = content + "<tr><td bgcolor='#00FF00'>Time</td><td>" + error[5] + "</td></tr>"
        content = content + "<tr><td bgcolor='#00FF00'>Msg</td><td>" + error[11].strip() + "</td></tr></table><br>"
        mailList.append(error[4])

    return [content, mailList]

errorInfo = getErrorInfo(sys.argv[1])
#buildInfo = getBuildInfo(sys.argv[2])
sendMail("mail.cfg", errorInfo)
