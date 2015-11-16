#! /bin/bash
#
# DESCRIPTION:	
# AUTHOR: 	Mohamed Osama (mohamed.osama.aboelkheir@gmail.com)
# CREATED: 	Tue 13-Nov-2015
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
Shows the dashboard for a specific day showing utlization, assigend cases, dispatched cases and closed cases\n\
\n\
OPTIONS:\n\
-u: print usage\n\
\n\
ARGS:\n\
DAY [OPTIONAL]: generate for this day (default is today)\n\
\n\
EMAPLES:\n\
$0 -> dashboard for today\n\
$0 \"13-Nov\" -> dashboard for 13 Nov\n\
$0 \"2015-11-13\" -> dashboard for 13 Nov\n"

}

#################
### Variables ###
#################
LOGIN=`dirname $0`/sf_login.sh

#################
### Options   ###
#################
while getopts ud OPT
do
    case $OPT in
        "u")
            usage
			exit 0	
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
	exit 1
fi

#Login
. $LOGIN
sf_login

echo 	"######################"
echo 	"##  `date -d "$DAY" +%d-%b`          ##"
echo 	"######################"
echo -n "## Utilization      ## "
`dirname $0`/sf_calc_tasks.sh $DAY | tail -1 | awk '{print $3}'
echo 	"######################"
echo -n "## Assigned cases   ## "
`dirname $0`/sf_assigned_cases.sh $DAY | tail -1 | awk '{print $3}'
echo 	"######################"
echo -n "## Closed cases     ## "
`dirname $0`/sf_closed_cases.sh $DAY | tail -1 | awk '{print $3}'
echo 	"######################"
echo -n "## Dispatched cases ## "
`dirname $0`/sf_dispatched_cases.sh $DAY | tail -1 | awk '{print $3}'
echo 	"######################"
