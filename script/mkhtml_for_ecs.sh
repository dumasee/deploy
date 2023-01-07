#!/bin/bash

#     
#     mkhtml_for_ecs.sh @ Version 0.25
#     date: 2022.05.19


function psql_script() {
    psql "host=127.0.0.1 port=15432 user=user1  password=User_123456 dbname=postgres" << EOF #2>/dev/null
 
SELECT ip_public,hostname,项目,用途,配置,费用,机房,状态,expired_date,threads,memory,disk,manufacturer FROM
    server_ecs
    ORDER BY 状态 DESC,项目,manufacturer,ip_public;
\q
EOF
}

now=$(date +%Y-%m-%d_%H%M%S)
csv=ecs.csv
html=ecs.html
home=/opt/nginx/html/ecs

psql_script |grep -v rows|grep -v +  | tee $csv
bash csv2html.sh $csv > $html
cp $html $home/$now.html
cp $html $home/index.html
