#! /bin/bash
#
# DESCRIPTION:	
# AUTHOR: 	Mohamed Osama (mohamed.osama.aboelkheir@gmail.com)
# CREATED: 	Tue 16-Jun-2015
# LAST REVISED:	Tue 13-Nov-2015
#
##############
# DISCLAIMER #
##############
# Anyone is free to copy, modify, use, or distribute this script for any purpose, and by any means. However, Please take care THIS IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND AND YOU SHOULD USE IT AT YOUR OWN RISK.

usage()
{
echo -e "USAGE: `basename $0` [-u] [-d] [DAY]\n\
\n\
DESCRIPTION:\n\
Used to calculate the utilization in a specific day\n\
\n\
OPTIONS:\n\
-d: detailed output\n\
-u: print usage\n\
\n\
ARGS:\n\
DAY [OPTIONAL]: generate for this day (default is today)\n\
\n\
EMAPLES:\n\
$0 -> get utilization for today\n\
$0 \"13-Nov\" -> get utilization for 13 Nov\n\
$0 -d \"2015-11-13\" -> get utilization for 13 Nov with detailed activity info\n"

}
#################
### Variables ###
#################
LOGIN=`dirname $0`/sf_login.sh
TMP_DIR=/tmp
TMP_FILE=$(mktemp $TMP_DIR/`basename $0`_`date +%Y%m%d%H%M%S`_XXXX)

#################
### Options   ###
#################
while getopts ud OPT
do
    case $OPT in
        "u")
            usage
			rm $TMP_FILE
			exit 0	
        ;;
        "d")
            DETAILED=1
        ;;
    esac
done

#################
### Arguments ###
#################
ARG=$(eval echo $`echo $OPTIND`)
[ "$ARG" ] && DAY=$ARG || DAY="today"
if ! DAY=`date -d "$DAY" +%Y-%m-%d`
then
	echo "ERROR: Wrong date format"
	usage
	rm $TMP_FILE
	exit 1
fi

#Login
. $LOGIN
sf_login

#TOTAL=`curl -s ${REST_URL}query/?q=SELECT+id,Ownerid,activitydate,duration__c+from+Task+WHERE+Ownerid+=+\'$USER_ID\'+and+activitydate=$DAY  -H "Authorization: Bearer $SESSION_ID" | sed "s/,/\n/g" | grep Duration | sed "s/\"Duration__c\"\:\([0-9\.]*\).*/\1/" | paste -s -d+|bc | cut -d. -f1`
curl -s ${REST_URL}query/?q=SELECT+id,Ownerid,activitydate,duration__c+from+Task+WHERE+Ownerid+=+\'$USER_ID\'+and+activitydate=$DAY  -H "Authorization: Bearer $SESSION_ID" > $TMP_FILE
TOTAL=`cat $TMP_FILE | sed "s/,/\n/g" | grep Duration | sed "s/\"Duration__c\"\:\([0-9\.]*\).*/\1/" | paste -s -d+|bc | cut -d. -f1`
 
if [ "$TOTAL" ]
then
	((HOURS=$TOTAL/60))
	((MINS=$TOTAL%60))
	HOURS=`printf "%02d\n" $HOURS`
	MINS=`printf "%02d\n" $MINS`
	echo "`date -d "$DAY" +%d-%b` => $HOURS:$MINS"
	if [ "$DETAILED" ]
	then
		echo -e "\n*** Task Details ***"
		cat $TMP_FILE | sed "s/},/},\n/g" 
		echo ""
	fi
else
	echo "`date -d "$DAY" +%d-%b` => no tasks found"
fi

rm $TMP_FILE
