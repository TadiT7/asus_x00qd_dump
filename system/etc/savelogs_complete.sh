#!/system/bin/sh

# check boot complete
android_boot=`getprop sys.boot_completed`

if [ "$android_boot" == "" || "$android_boot" == "0"]; then
	echo "boot not ready !!"
	exit
fi

uts=`getprop persist.asus.uts`
am broadcast -a $uts -p com.asus.loguploader
