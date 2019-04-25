#!/bin/bash
HOST=192.168.130.153
USER=root
PASSWORD=passwd4root
DATABASES=(`mysql -h$HOST -u$USER -p$PASSWORD -NBe "show databases" |xargs echo -n`)
BACKUP_PATH=/data/mysql_bak/$(date +%Y%m%d)
logfile=/data/mysql_bak/log/log-$(date +%Y%m%d).file
DATE=`date '+%Y%m%d'`

if [ ! -d $BACKUP_PATH ]
then
mkdir -p $BACKUP_PATH
fi
#进入到备份目录
cd $BACKUP_PATH

for db in ${DATABASES[*]}
 do
 mkdir -p $BACKUP_PATH/$db
 cd $BACKUP_PATH/$db
 table=$(mysql -h $HOST -u $USER -p$PASSWORD $db -e "show tables;"|sed '1d')
 for tb in $table
  do
   DUMPNAME=""$db"_"$tb"_"$DATE".sql"
   mysqldump -h $HOST -u $USER -p$PASSWORD $db $tb > $DUMPNAME
   if [ $? = 0 ];then
     echo "$DUMPNAME backup Successful!">>$logfile
   else
     echo "$DUMPNAME backup fail!" >>$logfile
   fi
  done
  tar zcf $BACKUP_PATH/${db}.tar.gz $BACKUP_PATH/${db}/
  rm -rf $BACKUP_PATH/${db}
done
