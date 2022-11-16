#!/bin/bash

#     
#     mkhtml_for_filmonitor.sh @ Version 0.17
#     date: 2022.05.19


function psql_script() {
    psql "host=127.0.0.1 port=15432 user=user1  password=User_123456 dbname=postgres" << EOF #2>/dev/null
 
SELECT name,account,power,wdpost,ip,delay,daemon,miner,nfs_number as nfs,daemon_log,miner_log,faults,disk_usage_lotus,to_char(time, 'yyyy-MM-dd HH24:mi:ss') as time FROM
        (
            SELECT
                ROW_NUMBER () OVER (
                    PARTITION BY account   -- 分组
                    ORDER BY time DESC  -- 按时间倒序
                ) AS rowNum ,*
            FROM 
            (
               SELECT filaccount."name",filaccount."sort",filaccount."wdpost",filmonitor."account",filmonitor."ip",filmonitor."delay",filmonitor."daemon_log",filmonitor."miner_log",filmonitor."daemon",filmonitor."miner",filmonitor."faults",filmonitor."time",filmonitor."disk_usage_lotus" ,filmonitor."nfs_ip",filmonitor."nfs_number",filmonitor."power" 
                   from filmonitor left join filaccount  
                   on filaccount."account"=filmonitor."account"
            ) d
        ) d
    WHERE rowNum = 1 and account != '' ORDER BY sort;
\q
EOF
}


now=$(date +%Y-%m-%d_%H%M%S)
csv=filmonitor.csv
html=filmonitor.html
home=/opt/nginx/html/fil

psql_script |grep -v rows|grep -v +  | tee $csv
bash csv2html.sh $csv > $html
cp $html $home/$now.html
cp $html $home/index.html