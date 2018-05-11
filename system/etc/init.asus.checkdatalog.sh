#!/system/bin/sh


# check boot complete
# android_boot=`getprop sys.boot_completed`

#if [ "$android_boot" == "" || "$android_boot" == "0"]; then
#	echo "boot not ready !!"
#	exit
#fi

# Workaround - permissive
# echo asussetenforce:0 > /proc/rd

# Parameter Definition
# $1: Caller

is_datalog_exist=`ls /data | grep logcat_log`
startlog_flag=`getprop persist.asus.startlog`
version_type=`getprop ro.build.type`
check_factory_version=`getprop ro.asus.factory`
is_sb=`grep -c SB=Y /proc/cmdline`
logcat_filenum=`getprop persist.asus.logcat.filenum`
is_clear_logcat_logs=`getprop sys.asus.logcat.clear`
MAX_ROTATION_NUM=30
Caller=`getprop sys.asus.check-data.caller`
if test "$Caller" != ""; then
	setprop sys.asus.check-data.caller ""
fi

 
is_unlocked=`grep -c UNLOCKED=Y /proc/cmdline`

######################################################################################
# For AsusLogTool logcat log rotation number setting
######################################################################################
if [ "$is_clear_logcat_logs" == "1" ]; then
	if [ "$logcat_filenum" != "3" ] && [ "$logcat_filenum" != "10" ] && [ "$logcat_filenum" != "20" ] && [ "$logcat_filenum" != "30" ]; then
		#if logcat_filenum get failed, sleep 1s and retry
		sleep 1
		logcat_filenum=`getprop persist.asus.logcat.filenum`

		if [ "$logcat_filenum" == "" ]; then
			logcat_filenum=20
		fi
	fi

	file_counter=$MAX_ROTATION_NUM
	while [ $file_counter -gt $logcat_filenum ]; do
		if [ $file_counter -lt 10 ]; then
			two_digit_file_counter=0$file_counter;
			
			if [ -e /data/logcat_log/logcat.txt.$two_digit_file_counter ]; then
				rm -f /data/logcat_log/logcat.txt.$two_digit_file_counter
			fi
		fi

		if [ -e /data/logcat_log/logcat.txt.$file_counter ]; then
			rm -f /data/logcat_log/logcat.txt.$file_counter
		fi
		
		file_counter=$(($file_counter-1))
	done

	setprop sys.asus.logcat.clear "0"
fi

######################################################################################
# For original logcat service startlog
######################################################################################
if test -e /data/logcat_log/bootcount; then
	var=$( cat /data/logcat_log/bootcount )
	var=$(($var+1))
	echo ${var}>/data/logcat_log/bootcount
	
	startlog_flag=`getprop persist.asus.startlog`

	if test "$is_datalog_exist"; then
		chown system.system /data/logcat_log
		chmod 0775 /data/logcat_log
		if test "$Caller" = "OOB"; then
			start logcat-oob
			start logcat-radio-oob
			start logcat-event-oob
		else
			if test "$startlog_flag" -eq 1;then
				start logcat
				start logcat-radio
				start logcat-events
				start logcat-asdf
				echo "A1"
			else
				stop logcat
				stop logcat-radio
				stop logcat-events
				stop logcat-asdf
				echo "A2"
			fi
		fi
	fi        	
else
	setprop persist.asus.ramdump 1
	setprop persist.asus.autosavelogmtp 0
	if  test "$version_type" = "eng"; then
		setprop persist.asus.startlog 1
		setprop persist.asus.kernelmessage 7
	elif test "$version_type" = "userdebug"; then
			if test "$check_factory_version" = "1"; then
				if test "$is_sb" = "1"; then
					setprop persist.asus.kernelmessage 0
				else
					setprop persist.asus.kernelmessage 7
				fi
				setprop persist.asus.enable_navbar 1
			else
				setprop persist.asus.kernelmessage 0	
			fi
		setprop persist.asus.startlog 1
		setprop persist.sys.downloadmode.enable 1
		
	fi
	
	recheck_datalog=`ls /data | grep logcat_log`

	if test "$recheck_datalog"; then
		chown system.system /data/logcat_log
		chmod 0775 /data/logcat_log
		if test "$Caller" = "OOB"; then
			start logcat-oob
			start logcat-radio-oob
			start logcat-event-oob
		else
			if test "$version_type" = "user";then
				startlog_flag=`getprop persist.asus.startlog`
				if test "$startlog_flag" -eq 1;then
					start logcat
					start logcat-radio
					start logcat-events
					start logcat-asdf
					echo "B1"
				else
					stop logcat
					stop logcat-radio
					stop logcat-events
					stop logcat-asdf
					echo "B2"
				fi
			else
				start logcat
				start logcat-radio
				start logcat-events
				start logcat-asdf
				echo "B3"
			fi
		fi
	fi
	echo 1 >/data/logcat_log/bootcount
	echo "[Debug] The file bootcount doesn't exist, data partition might be erased(factory reset)" > /proc/asusevtlog	
fi

if test "$is_unlocked" = "1"; then
	start logcat-asdf
fi

# Workaround - enforce
# echo asussetenforce:1 > /proc/rd

