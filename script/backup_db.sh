#!/bin/bash

#     
#     backup_db.sh @ Version 0.17
#     date: 2022.11.04

. /etc/profile
readonly db_host="127.0.0.1"
readonly db_port="3306"   #default: mysql is 3306,postgresql is 5432
readonly db_user="root"
readonly db_pass='123456'
readonly db_name=''
readonly dir_backup=/opt/mysql_bak/
readonly f=$(date +%Y-%m-%d_%H%M%S).sql
export PGPASSWORD=$db_pass


backup_db(){
    [ ! -d $dir_backup ] && mkdir -p $dir_backup
    /usr/bin/mysqldump -h $db_host -P $db_port -u $db_user -p$db_pass --databases $db_name --set-gtid-purged=off --default-character-set=utf8 --opt -Q -R --skip-lock-tables > $dir_backup/$f
    #/usr/bin/pg_dump -h $db_host -p $db_port --column-inserts -U $db_user $db_name > $dir_backup/$f
    #/usr/bin/mysqldump -h $db_host -P $db_port -u $db_user -p$db_pass --all-databases --default-character-set=utf8 --opt -Q -R --skip-lock-tables > $dir_backup/$f

    tar -czf $dir_backup/$f.tar.gz -C $dir_backup $f
    rm -f $dir_backup/$f
}


clean_old(){
    flist=$(du -sh $dir_backup/*.tar.gz |awk  '{print $2}' | head -n -7)   #保留最新的7个备份
    for  f_del in $flist
    do
        rm -rf $f_del && echo $f_del deleted.
    done
}

backup_db
clean_old


#crontab -e
#0 7 * * * bash /opt/backup_db.sh