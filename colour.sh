#! /bin/bash
#set -x
clear
printf '\n\n\n\n\n\n\n\n\n\n'
iteration=$2
text=$1
length=${#text}
COLUMNS=$(tput cols) 
for (( c=1; c<=$iteration; c++ ))
do
	tput setaf $c
	printf "%*s" $(((${#text}+$COLUMNS)/2)) "$text"
	sleep $3
	printf '\r'
done
