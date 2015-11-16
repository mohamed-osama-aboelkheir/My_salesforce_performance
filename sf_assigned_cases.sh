#! /bin/bash
#
# DESCRIPTION:	
# AUTHOR: 	Mohamed Osama (mohamed.osama.aboelkheir@gmail.com)
# CREATED: 	Tue 13-Jul-2015
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
Used to List the cases assigned to a user in a specific day\n\
\n\
OPTIONS:\n\
-d: detailed output\n\
-u: print usage\n\
\n\
ARGS:\n\
DAY [OPTIONAL]: generate for this day (default is today)\n\
\n\
EMAPLES:\n\
$0 -> get cases for today\n\
$0 \"13-Nov\" -> get cases for 13 Nov\n\
$0 -d \"2015-11-13\" -> get cases for 13 Nov with detailed case info\n"

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

START=`date -d "$DAY 12:00 AM" +%Y-%m-%dT00:00:00Z`
END=`date -d "$DAY 12:00 AM + 1 day" +%Y-%m-%dT00:00:00Z`

#Login
. $LOGIN
sf_login

echo -n "`date -d "${DAY}" +%d-%b` => "
curl -s ${REST_URL}query/?q=SELECT+id,Caseid,createddate,field,oldvalue,newvalue+from+CaseHistory+WHERE+createddate\>$START+and+createddate\<$END+and+field=\'Owner\' -H "Authorization: Bearer $SESSION_ID" | sed "s/}/}\n/g" | grep "\"NewValue\":\"Mohamed AboElKheir\"" > $TMP_FILE 
cat $TMP_FILE | wc -l

if [ "$DETAILED" ]
then
	echo -e "\n*** Case Details ***"
	cat $TMP_FILE
fi

rm $TMP_FILE
