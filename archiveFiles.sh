#!/bin/bash
logFile=fileArchiever.log
basePath=./archiveFolder
silent=0
#set -x
display_usage() {
	echo "usage: $programname [-hsld] [-b before days]"
    echo "  -s      run silently"
    echo "  -d      base directory for archiving. Destination folder path. DEFAULT $basePath"
    echo "  -l      to specify custom log file. DEFAULT $logFile"
    echo "  -b      to specify archive before period. Integer value in days.[Should be greater then 0]"
    echo "  -h      display help"
    exit 1
	}

for i in "$@"
do
case $i in
    -h*|--help*)
    display_usage
    exit 2
    ;;
    -s*|--silent*)
    silent=1
    shift # past argument=value
    ;;
    -b=*|--before=*)
    purgeBefore="${i#*=}"
    shift # past argument=value
    ;;
    -l=*|--logfile=*)
    logFile="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--directory=*)
    basePath="${i#*=}"
    shift # past argument=value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
          # unknown option
    ;;
esac
done
if [ -z $purgeBefore ]; then
    echo "Specify time from when to purge"
    display_usage
fi

if [ $purgeBefore -lt 0 ]
then
	echo "Cannot archive file" >&2
	echo "Invalid purgeBefore time, Use -b 'or' --before with value greater then 0" >&2
	display_usage
fi
echo -e "---------------------------------------------" >> $logFile
echo $(date) >> $logFile
echo -e "----------------START-----------------------------" >> $logFile
echo "Purge Before = $purgeBefore" >> $logFile
echo "Base Path = $basePath" >> $logFile
STARTTIME=$(date +%s)
count=0
mkdir -p $basePath;
for i in $(find . -maxdepth 1 -mtime +$purgeBefore | cut -sd / -f 2-);
	do
		if [ $i != $basePath ]
		then
			directory=$basePath/$(ls -ld --time-style=long-iso $i | awk '{print $6}')
			mkdir -p $directory;
			if (( $silent == 0 ))
		        then
				echo "Moving file $i to directory $directory"
			fi
			echo "Moving file $i to directory $directory" >> $logFile
			mv $i $directory
			((count=count+1))
		fi
	done
ENDTIME=$(date +%s)
echo -e "Moved $count files in $(($ENDTIME - $STARTTIME)) seconds\n"
echo -e "Moved $count files in $(($ENDTIME - $STARTTIME)) seconds\n" >> $logFile
echo -e "-----------------END------------------------------\n\n" >> $logFile
