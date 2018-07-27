#!/bin/sh

TAG="BMS"
ret=`/system/bin/batt_type 1`
if [ "$ret" == "CSL_51K" ];	then
	log -t "$TAG" "set batt property as 1 for 51K.."
	setprop atd.batteryid.status PASS
	echo "ok 1"
else
	log -t "$TAG" "set batt property as 0.."
	setprop atd.batteryid.status FAIL
	echo "ok 0"
fi

