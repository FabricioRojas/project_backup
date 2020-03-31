# Project Buckup

Is a simple way to keep all youyr projects backedup

The scrip first backup the database and then upload all the project changes included the DB backup into any repository you want

> **Current supported Databases:** Mysql, Mongo, Postgresql


The script is thought to be used in a CRON TASk but could be executed manually anyway


## CRON example: 

```
0 0 * * * curl -s https://raw.githubusercontent.com/FabricioRojas/project_backup/master/backup.sh | bash -s PROJECT_DIR PROJECT_NAME SMTP_TO SMTP_USER SMTP_PASS DB_TYPE DB_NAME DB_USER DB_PASS DB_HOST RP_BRANCH RP_MESSAGE RP_ORIGIN
```
This CRON example use the online files from **this** repository, but you you need to do some changes youll need to download the files and modify the CRON statement


- **PROJECT_DIR** -- required
    > Project full path

- **PROJECT_NAME** -- required
    > Project name that will be used on the backup files

- **SMTP_TO** -- required
    > Email where the messages will be sent

- **SMTP_USER** -- required
    > SMTP username, defualt smtp service is "sendgrid" and the default port is "465" you can change at sendMail.php line 22/23

- **SMTP_PASS** -- required
    > SMTP password

- **DB_TYPE** -- required
    > mysql || postgresql || mongo

- **DB_NAME** -- required
    > Database name

- **DB_USER**
    > Database username

- **DB_PASS**
    > Database password

- **DB_HOST** 
    > Database host

- **RP_BRANCH**
    > Repository branch name

- **RP_MESSAGE**
    > Commit default message

- **RP_ORIGIN**
    > Repository remote name
