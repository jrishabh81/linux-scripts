#!/bin/bash
sek=60
echo "60 Seconds Wait!"
echo -n "One Moment please "
while [ $sek -ge 1 ]
do
   echo -n "$sek" #print sek
   sleep 1
   sek=$[$sek-1] #update sek
   echo -en "\b\b\b" #'print' backtrace
done
echo
echo "ready!"
