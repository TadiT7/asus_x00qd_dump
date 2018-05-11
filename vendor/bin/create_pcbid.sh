#!/vendor/bin/sh

echo "PCBID TEST: +++"

rm /data/data/pcbid_status_str_tmp

PROP_STAGE=$(getprop ro.boot.id.stage)
PROP_PROJECT=$(getprop ro.boot.id.prj)

STAGE=
PROJECT=

case $PROP_PROJECT in
	"6" )
		PROJECT='ZE620KL'
		echo "PCBID TEST: PROJECT="$PROJECT
		;;
	*)
		PROJECT='UNKNOW('$PROP_PROJECT')'
		echo "PCBID TEST: PROJECT="$PROJECT
		;;
esac

case $PROP_STAGE in
	"0" )
		STAGE='SR'
		echo "PCBID TEST: STAGE="$STAGE
		;;
	"1" )
		STAGE='SR2'
		echo "PCBID TEST: STAGE="$STAGE
		;;
	"2" )
		STAGE='ER1'
		echo "PCBID TEST: STAGE="$STAGE
		;;
	"3" )
		STAGE='ER2'
		echo "PCBID TEST: STAGE="$STAGE
		;;
	"4" )
		STAGE='PR'
		echo "PCBID TEST: STAGE="$STAGE
		;;
	"7" )
		STAGE='MP'
		echo "PCBID TEST: STAGE="$STAGE
		;;
	*)
		STAGE='UNKNOW('$PROP_STAGE')'
		echo "PCBID TEST: STAGE="$STAGE
		;;
esac

echo $PROJECT"_"$STAGE > /data/data/pcbid_status_str_tmp
chmod 00777 /data/data/pcbid_status_str_tmp

echo "PCBID TEST: ---"
