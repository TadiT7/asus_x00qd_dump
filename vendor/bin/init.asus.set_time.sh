#!/vendor/bin/sh

#ASUS_BSP +++ Show_Cai set default time
#sleep 5
#current_year=$(date +%Y)

#if [ "${current_year}" -gt 2000 ] && [ -f /data/set_time ]; then
#	setprop persist.asus.set_default_time 1
#fi

#set_default_time=`getprop persist.asus.set_default_time`

#if [ "${set_default_time}" != 1 ];then
#	date 0101000016.00
#	setprop persist.asus.set_default_time 1
#elif [ "${current_year}" -lt 1980 ]; then
#	date 0101000016.00
#fi
#ASUS_BSP --- Show_Cai set default time

#ASUS_BSP +++ "[RTC] RTC Service for asus time & timezone issue"

# No path is set up at this point so we have to do it here.
#PATH=/sbin:/system/sbin:/system/bin:/system/xbin
#export PATH
export PATH=/vendor/bin

first_boot=`getprop persist.asus.first_boot`

echo "[ASUS][SET_TIME] Begin Set timezone" > /dev/kmsg
log -p d -t [ASUS][SET_TIME] Begin Set timezone
echo "[ASUS][SET_TIME] Set persist.asus.first_boot = $first_boot" > /dev/kmsg
log -p d -t [ASUS][SET_TIME] Set timezone persist.asus.first_boot = "$first_boot"

if [ "${first_boot}" != 1 ] || [ ! -f /data/property/persist.asus.first_boot ];then
	customer=$(cat /factory/CUSTOMER)
	
	echo "[ASUS][SET_TIME] /factory/CUSTOMER = $customer" > /dev/kmsg
	log -p d -t [ASUS][SET_TIME] /factory/CUSTOMER = "$customer"
	
	if [ "$customer" == "VF_IT" ] || [ "$customer" == "TIM" ];then
		setprop persist.sys.timezone "Europe/Brussels"
		echo "[ASUS][SET_TIME] Set persist.sys.timezone to Europe/Brussels" > /dev/kmsg
		log -p d -t [ASUS][SET_TIME] Set persist.sys.timezone to Europe/Brussels
	fi
	setprop persist.asus.first_boot 1
fi

echo "[ASUS][SET_TIME] End Set timezone" > /dev/kmsg
log -p d -t [ASUS][SET_TIME] End Set timezone
#ASUS_BSP ---
