#!bin/bash

ticketmodi="$(tr ' ' '\n' < syslog.log | grep "modified" | wc -l)"
permiden="$(tr ' ' '\n' < syslog.log | grep "Permission" | wc -l)"
triedadd="$(tr ' ' '\n' < syslog.log | grep "Tried" | wc -l)"
timeout="$(tr ' ' '\n' < syslog.log | grep "Timeout" | wc -l)"
doesnt="$(tr ' ' '\n' < syslog.log | grep "exist" | wc -l)"
connect="$(tr ' ' '\n' < syslog.log | grep "Connection" | wc -l)"


echo "The ticket was modified while updating,$ticketmodi 
Permission denied while closing ticket,$permiden
Tried to add information to closed ticket,$triedadd
Timeout while retrieving information,$timeout 
Ticket doesn't exist,$doesnt 
Connection to DB failed,$connect" |
sort -n -r -t',' -k2 | sed '1i Error,Count' > error_message.csv


echo "Username,INFO,ERROR" > user_statistic.csv |
tr ' ' '\n' < syslog.log > tmp1.txt
grep -o "(.*)" tmp1.txt | tr -d "(" | tr -d ")" | sort | uniq >> tmp2.txt
while read user
do
info=$(grep "INFO.*($user)" syslog.log | wc -l)
error=$(grep "ERROR.*($user)" syslog.log | wc -l)
echo "$user,$info,$error" >> user_statistic.csv 
done < tmp2.txt 

