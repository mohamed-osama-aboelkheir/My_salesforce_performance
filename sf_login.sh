#! /bin/bash
#
# DESCRIPTION:	
# AUTHOR: 	Mohamed Osama (mohamed.osama.aboelkheir@gmail.com)
# CREATED: 	Tue 16-Jun-2015
# LAST REVISED:	Tue 16-Jun-2015
#
##############
# DISCLAIMER #
##############
# Anyone is free to copy, modify, use, or distribute this script for any purpose, and by any means. However, Please take care THIS IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND AND YOU SHOULD USE IT AT YOUR OWN RISK.


usage()
{
echo "USAGE: `basename $0` [options] args"
}

SOAP_URL="https://login.salesforce.com/services/Soap/u/34.0"
REST_URL="services/data/v34.0/"

sf_login()
{
	OUTPUT="/tmp/sf_login.xml"
	if [ -e "$OUTPUT" ]
	then
		SESSION_ID=`grep "<sessionId>.*</sessionId>" $OUTPUT | sed "s/<sessionId>\(.*\)<\/sessionId>/\1/"`
		if [ "$SESSION_ID" ]
		then
			if ! curl -s $REST_URL -H "Authorization: Bearer $SESSION_ID" | grep INVALID_SESSION_ID &> /dev/null 
			then
				USER_ID=`grep "<userId>.*</userId>" $OUTPUT | head -1 | sed "s/<userId>\(.*\)<\/userId>/\1/"`
				REST_URL=`grep "<serverUrl>.*</serverUrl>" $OUTPUT | sed "s/.*\(https:\/\/[^/]*\).*/\1/"`/$REST_URL
				echo "<< SESSION FOUND >>"
				return 0
			fi
		fi
	fi
	
	
	for i in {1..3}
	do
		read -p "Username :" USERLOGIN
		read -s -p "Password :" PASSWORD
		echo ""
		echo "<?xml version=\"1.0\" encoding=\"utf-8\" ?>
	<env:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
	    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
	    xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\">
	  <env:Body>
	    <n1:login xmlns:n1=\"urn:partner.soap.sforce.com\">
	      <n1:username>$USERLOGIN</n1:username>
	      <n1:password>$PASSWORD</n1:password>
	    </n1:login>
	  </env:Body>
	</env:Envelope>" | curl $SOAP_URL -s -H "Content-Type: text/xml; charset=UTF-8" -H "SOAPAction: login" -d @- | sed "s/></>\n</g" > $OUTPUT
	
	if grep "<sessionId>.*</sessionId>" $OUTPUT &> /dev/null
	then
		SESSION_ID=`grep "<sessionId>.*</sessionId>" $OUTPUT | sed "s/<sessionId>\(.*\)<\/sessionId>/\1/"`
		USER_ID=`grep "<userId>.*</userId>" $OUTPUT | head -1 | sed "s/<userId>\(.*\)<\/userId>/\1/"`
		REST_URL=`grep "<serverUrl>.*</serverUrl>" $OUTPUT | sed "s/.*\(https:\/\/[^/]*\).*/\1/"`/$REST_URL
		echo "<< LOGIN SUCCESS >>"
		return 0
	else
		echo ">> LOGIN FAILED!! <<"
	fi
	
	done
	echo "ERROR: Invalid login ..exiting"
	exit 1
}

