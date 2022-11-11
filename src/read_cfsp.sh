#!/usr/bin/env bash

# Read the date and power output from a Cloudfree smart plug

PLUGID=$1
IPADDR="192.168.1.$PLUGID"
LOGPATH=/data/sp${PLUGID}_power.log

curl -s http://$IPADDR/cm?cmnd=Status%208 \
     | jq -r "[.StatusSNS.Time, .StatusSNS.ENERGY.Power] | @csv" \
     >> $LOGPATH
