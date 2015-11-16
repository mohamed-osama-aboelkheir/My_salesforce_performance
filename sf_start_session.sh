#! /bin/bash
#
# DESCRIPTION:	
# AUTHOR: 	Mohamed Osama (mohamed.osama.aboelkheir@gmail.com)
# CREATED: 	Wed 14-Oct-2015
# LAST REVISED:	Wed 14-Oct-2015
#
##############
# DISCLAIMER #
##############
# Anyone is free to copy, modify, use, or distribute this script for any purpose, and by any means. However, Please take care THIS IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND AND YOU SHOULD USE IT AT YOUR OWN RISK.


usage()
{
echo "USAGE: `basename $0` [options] args"
}

LOGIN=`dirname $0`/sf_login.sh

#Login
. $LOGIN
sf_login

