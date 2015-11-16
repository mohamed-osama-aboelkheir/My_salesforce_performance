# My_salesforce_performance
A cli interface connecting to salesforce, to show some basic performance reports for users using salesforce Cases.

## Requirements:
1. Bash
2. curl

## Usage:
This can be used to get the utilization (task duration), closed cases, assigned cases, and dispatched cases of the logged in user for a certain day (default is current day).

The first time you run any of the scripts you will be asked for a user name and a password, this will open a session, and you will no longer be required to enter your credentails until the session expires.

### 1. sf_calc_tasks.sh
This script can be run to get the utilization (task duration) of the logged in user for a certain day (default is current day).
If used with no arguments This will show the total utilization for current day.
```
# ./sf_calc_tasks.sh
<< SESSION FOUND >>
16-Nov => 01:12
```
If you want a previous day, you can enter the date as an argument.
```
# ./sf_calc_tasks.sh "Nov 13"
<< SESSION FOUND >>
13-Nov => 06:31
```
If you want to see the tasks in detail use the -d option.
```
# ./sf_calc_tasks.sh -d "Nov 13"
```
If you use the -u option, this will print the usage details:
```
# ./sf_calc_tasks.sh -u
```

### 2. sf_closed_cases.sh
This script can be run to get the closed cases of the logged in user for a certain day (default is current day).
If used with no arguments This will show the total closed cases for current day.
```
# ./sf_closed_cases.sh
<< SESSION FOUND >>
16-Nov => 2
```
If you want a previous day, you can enter the date as an argument.
```
# ./sf_closed_cases.sh "Nov 13"
<< SESSION FOUND >>
13-Nov => 4
```
If you want to see the cases in detail use the -d option.
```
# ./sf_closed_cases.sh -d "Nov 13"
```
If you use the -u option, this will print the usage details:
```
# ./sf_closed_cases.s -u
```

### 3. sf_assigned_cases.sh
This script can be run to get the assigned cases to the logged in user for a certain day (default is current day).
If used with no arguments This will show the total assigned cases for current day.
```
# ./sf_assigned_cases.sh
<< SESSION FOUND >>
16-Nov => 3
```
If you want a previous day, you can enter the date as an argument.
```
# ./sf_assigned_cases.sh "Nov 13"
<< SESSION FOUND >>
13-Nov => 5
```
If you want to see the cases in detail use the -d option.
```
# ./sf_assigned_cases.sh -d "Nov 13"
```
If you use the -u option, this will print the usage details:
```
# ./sf_assigned_cases.sh -u
```

### 4. sf_dispatched_cases.sh
This script can be run to get the dispatched cases from the logged in user for a certain day (default is current day).
If used with no arguments This will show the total dispatched cases for current day.
```
# ./sf_dispatched_cases.sh
<< SESSION FOUND >>
16-Nov => 1
```
If you want a previous day, you can enter the date as an argument.
```
# ./sf_dispatched_cases.sh "Nov 13"
<< SESSION FOUND >>
13-Nov => 2
```
If you want to see the cases in detail use the -d option.
```
# ./sf_dispatched_cases.sh -d "Nov 13"
```
If you use the -u option, this will print the usage details:
```
# ./sf_dispatched_cases.sh -u
```

### 5. sf_dashboard.sh
This script can be used to show a dashboard for a certain day showin all above statistics.
If used with no arguments This will show the total dispatched cases for current day.
```
# ./sf_dashboard.sh
<< SESSION FOUND >>
######################
##  16-Nov          ##
######################
## Utilization      ## 01:12
######################
## Assigned cases   ## 3
######################
## Closed cases     ## 2
######################
## Dispatched cases ## 1
######################

```
If you want a previous day, you can enter the date as an argument.
```
# ./sf_dashboard.sh "Nov 13"
<< SESSION FOUND >>
######################
##  13-Nov          ##
######################
## Utilization      ## 06:31
######################
## Assigned cases   ## 3
######################
## Closed cases     ## 4
######################
## Dispatched cases ## 2
######################

```
