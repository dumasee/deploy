#!/bin/bash

#     
#     csv2html.sh @ Version 0.19
#     date: 2022.05.09


[ -n "$1" ] && CSVFILE=$1
#CSVFILE='/root/test123456.csv'
TD_STR=''

#this function create a <td> block
create_td()
{
  #echo $1
  #TD_STR=`echo $1 | awk 'BEGIN{FS=","}{i=1; while(i<=NF) {print "<td>"$i"</td>";i++}}'`
  TD_STR=`echo $1 | awk 'BEGIN{FS="|"}{i=1; while(i<=NF) {print "<td>"$i"</td>";i++}}'`
}
#this function create a row html script(<tr>block).
create_tr()
{
  create_td "$1"
  echo -e "<tr>\n$TD_STR\n<tr/>\n"
}
#create html script head
create_html_head()
{
  #echo -e "<html>\n<body>\n<h1>$CSVFILE</h1>\n"
  echo -e "<html>\n<body>\n"
  echo -e "<head>\n<meta charset="utf-8">\n</head>\n"
}
#create html script end
create_html_end()
{
  echo -e "</body></html>"
}
create_table_head()
{
  echo -e "<table border="2" cellspacing="0" cellpadding="2" align="left">\n"
}
create_table_end()
{
   echo -e "</table>\n"
}
create_html_head
create_table_head
while read LINE
do
 # echo "$LINE"
  create_tr "$LINE"
done < $CSVFILE
create_table_end
create_html_end
