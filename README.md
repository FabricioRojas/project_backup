CRON example: 

0 0 * * * curl -s https://raw.githubusercontent.com/FabricioRojas/project_backup/master/backup.sh | bash -s PROJECT_DIR PROJECT_NAME SMTP_TO SMTP_USER SMTP_PASS DB_TYPE DB_NAME DB_USER DB_PASS DB_HOST RP_BRANCH RP_MESSAGE RP_ORIGIN


* PROJECT_DIR => Project full path **required**

* PROJECT_NAME => Project name that will be used on the backup files **required**

* SMTP_TO => Email where the messages will be sent **required**

* SMTP_USER => SMTP username, defualt smtp service is "sendgrid" and the default port is "465" you can change at sendMail.php line 22/23 **required**

* SMTP_PASS => SMTP password **required**

* DB_TYPE => mysql || postgresql || mongo **required**

* DB_NAME => Database name **required**

* DB_USER => Database username

* DB_PASS => Database password

* DB_HOST => Database host

* RP_BRANCH => Repository branch name

* RP_MESSAGE => Commit default message

* RP_ORIGIN => Repository remote name
