#!/bin/bash
now=$(date +"%m_%d_%Y")
yest=$(date -d "yesterday" +"%m_%d_%Y")
project_dir=$1
project_name=$2
smtp_to=$3
smtp_user=$4
smtp_pass=$5
db_type=$6
db_name=$7
db_user=$8
db_pass=$9
db_host=${$10}
rp_branch=${11}
rp_message=${12}
rp_origin=${13}
current_dir=`dirname $0`
error=false
errorMessage=""

if [ -z "$rp_origin" ]
then
    rp_origin="origin"
fi
if [ -z "$rp_message" ]
then
    rp_message="Project backup"
fi
if [ -z "$rp_branch" ]
then
    rp_branch="master"
fi
if [ -z "$db_host" ]
then
    db_host="localhost"
fi

cd $project_dir
if [ $db_type == 'mysql' ]
then
    echo MySql db selected
    errorMessage="MySql db selected"

    mysqldump  -h $db_host -u $db_user -p$db_pass $db_name  >  $project_name-dump-$now.sql

    filesize=$(stat -c%s "$project_dir/$project_name-dump-$now.sql")
    if [ $filesize -lt 1 ]
    then
        error=true
        errorMessage=$errorMessage" - Couldn't create dump"
    else
        rm $project_name-dump-$yest.sql
    fi
elif [ $db_type == 'mongo' ]
then
    echo Mongo db selected
    errorMessage="Mongo db selected"

    mongodump -h $db_host -d $db_name -o $project_name-dump-$now
    zip -r $project_name-dump-$now.zip $project_name-dump-$now

    filesize=$(stat -c%s "$project_dir/$project_name-dump-$now")
    if [ $filesize -lt 1 ]
    then
        error=true
        errorMessage=$errorMessage" - Couldn't create zip file"
    else
        rm -rf $project_name-dump-$now
        rm -rf $project_name-dump-$yest.zip
    fi
elif [ $db_type == 'postgresql' ]
then
    echo PostgreSQL db selected
    errorMessage="PostgreSQL db selected"

    pg_dump -U $db_user $db_name > $project_name-dump-$now.dmp

    filesize=$(stat -c%s "$project_dir/$project_name-dump-$now.dmp")
    if [ $filesize -lt 1 ]
    then
        error=true
        errorMessage=$errorMessage" - Couldn't create dmp file"
    else
        rm $project_name-dump-$yest.dmp
    fi
else
    error=true
    errorMessage="Unknown db selected"
    echo Unknown db selected
fi

git add -A
git commit -m "$rp_message $now"
git push $rp_origin $rp_branch
gitStatus=$(git status)

if echo "$gitStatus" | grep -q "nothing to commit, working directory clean"; then
  echo "matched";
else
  error=true
  errorMessage=$errorMessage" - Failed to push changes into repo: "$gitStatus
fi

echo "ErroR>"$error

if [ $error == true ]
then
  echo $errorMessage
  php -r "$(curl -s https://raw.githubusercontent.com/FabricioRojas/project_backup/master/sendMail.php)" $smtp_to $smtp_user $smtp_email $smtp_pass $project_name $errorMessage
else
  echo Dump finished
fi 

#crontab -e || nano /var/spool/cron/crontabs/root
#0 0 * * * curl -s https://raw.githubusercontent.com/FabricioRojas/project_backup/master/backup.sh | bash -s PROJECT_DIR PROJECT_NAME SMTP_TO SMTP_USER SMTP_PASS DB_TYPE DB_NAME DB_USER DB_PASS DB_HOST RP_BRANCH RP_MESSAGE RP_ORIGIN