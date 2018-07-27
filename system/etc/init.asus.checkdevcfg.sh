#!/system/bin/sh

# check boot complete
android_boot=`getprop sys.boot_completed`
if [ "$android_boot" == "" || "$android_boot" == "0"]; then
	echo "boot not ready !!"
	exit
fi

# check downloadmode flag & devcfg
downloadmode=`getprop persist.sys.downloadmode.enable`
platform=`getprop ro.boot.id.prj`
if [ "$downloadmode" == "1" ]; then
	echo asussetenforce:0 > /proc/rd
	if [ "$platform" == "6" ]; then
		dd if=/system/vendor/etc/devcfg_636_tzOn.mbn of=/data/devcfg_system.mbn bs=1024 count=47
	fi
	dd if=/dev/block/mmcblk0p9 of=/data/devcfg_check.mbn bs=1024 count=47
	devcfgcheck=`md5sum -b /data/devcfg_check.mbn`
	devcfgsystem=`md5sum -b /data/devcfg_system.mbn`
else
	exit
fi

# load devcfg
if [ "$devcfgcheck" != "$devcfgsystem" ]; then
	if [ "$platform" == "6" ]; then
		dd if=/system/vendor/etc/devcfg_636_tzOn.mbn of=/dev/block/mmcblk0p9
	fi
	echo "[Debug] Load devcfg and reboot" > /proc/asusevtlog
	reboot
else
	echo asussetenforce:1 > /proc/rd
	exit
fi
echo asussetenforce:1 > /proc/rd
