#!/vendor/bin/sh
export PATH=/vendor/bin:/vendor/xbin
echo "PATH = "$PATH

GENERAL_LOG=/data/media/0/ASUS/LogUploader/general/sdcard
echo "GENERAL_LOG = "$GENERAL_LOG
#savelogs_prop=`getprop persist.asus.savelogs`

#if [ ".$savelogs_prop" == ".1" ] || [ ".$savelogs_prop" == ".4" ]; then
	# create folder
	mkdir -p $GENERAL_LOG
	echo "mkdir -p $GENERAL_LOG"
	# save demsg
	dmesg > $GENERAL_LOG/dmesg.txt
	echo "dmesg > $GENERAL_LOG/dmesg.txt"
#fi

