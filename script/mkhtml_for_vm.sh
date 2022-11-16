#!/bin/bash

#     
#     mkhtml_for_vm.sh @ Version 0.3
#     date: 2022.08.09


function psql_script() {
    psql "host=127.0.0.1 port=15432 user=user1  password=User_123456 dbname=postgres" << EOF #2>/dev/null
 
SELECT ip,ip_public,hostname,项目,用途,状态,note,threads,memory,disk,manufacturer FROM
    server_vm
    ORDER BY 状态 DESC,ip;
\q
EOF
}

now=$(date +%Y-%m-%d_%H%M%S)
csv=vm.csv
html=vm.html
home=/opt/nginx/html/vm

psql_script |grep -v rows|grep -v +  | tee $csv
bash csv2html.sh $csv > $html
cp $html $home/$now.html
cp $html $home/index.html