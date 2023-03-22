#!/bin/bash

# set expected default DEV_PATH with no params
DEV_PATH="/dev/cdc-wdm0"

if [ "$#" -eq 1 ]; then
    if [[ "$1" =~ /dev/cdc-wdm[0-9] ]]; then
        DEV_PATH=$1
    fi
fi

# Extract Country Code
extract_cc()
{
    eval string="$1"
    echo "Country Code: $(echo $string | awk '{print substr($0, 4, 3 )}')"
}

# Extract operator ID
extract_id()
{
    eval string="$1"
    echo "Operator ID: $(echo $string | awk '{print substr($0, 7, 2 )}')"
}

# set the name of executable
PROG="qmicli -p -d"

# set the parameters
PARAMS="--uim-read-transparent=0x3F00,0x7FFF,0x6F07"

CALL="$PROG $DEV_PATH $PARAMS"


# RES=$($CALL)

# root@omnia-1G:~# qmicli -p -d /dev/cdc-wdm0 --uim-read-transparent=0x3F00,0x7FFF,0x6F07
# [/dev/cdc-wdm0] Successfully read information from the UIM:
# Card result:
#     SW1: '0x90'
#     SW2: '0x00'
# Read result:
#     08:29:03:20:20:30:04:35:80

# get the correct line from the output
# grep -E '([0-9]{2}:){8}[0-9]{2}'

# remove blanks and
# sed -E 's/ //g;

# switch even with odd characters 08 > 80 etc.
# sed -E 's/(.)(.):?/\2\1/g;'

# replace `cat mock` by $RES
IMSI=$(cat mock | grep -E '([0-9]{2}:){8}[0-9]{2}' | sed -E 's/ //g;s/(.)(.):?/\2\1/g;')

# TODO: check=success_check $IMSI

extract_cc $IMSI
extract_id $IMSI
