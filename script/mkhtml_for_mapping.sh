#!/bin/bash

#     
#     mkhtml_for_mapping.sh.sh @ Version 0.7
#     date: 2022.06.22



now=$(date +%Y-%m-%d_%H%M%S)
csv=mapping.csv
html=mapping.html
home=/opt/nginx/html/mapping


echo '外网地址|外网端口|内网地址|内网端口' |tee $csv
cat *.fw |grep -v " 22 rule"|grep global|awk '{print $6"|"$7"|"$9"|"$10}'  | tee -a $csv
bash csv2html.sh $csv > $html
cp $html $home/$now.html
cp $html $home/index.html



