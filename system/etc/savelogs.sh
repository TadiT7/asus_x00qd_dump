#!/system/bin/sh

# Workaround - permissive
#echo asussetenforce:0 > /proc/rd

#LogUnlock
LOG_UNLOCK=`cat /asdf/LogUnlock.txt`
if [ "$LOG_UNLOCK" == "" ] || [ "$LOG_UNLOCK" == "0" ]; then
	echo "[LogTool] LOG_UNLOCK exit" > /proc/asusevtlog
	exit
fi

#MODEM_LOG
MODEM_LOG=/data/media/0/ASUS/LogUploader/modem
#MODEM_LOG=/sdcard/ASUS/LogUploader/modem
#TCP_DUMP_LOG
TCP_DUMP_LOG=/data/media/0/ASUS/LogUploader/TCPdump
#TCP_DUMP_LOG=/sdcard/ASUS/LogUploader/TCPdump
#GENERAL_LOG
GENERAL_LOG=/data/media/0/ASUS/LogUploader/general/sdcard
#GENERAL_LOG=/sdcard/ASUS/LogUploader/general/sdcard

#Dumpsys folder
DUMPSYS_DIR=/data/media/0/ASUS/LogUploader/dumpsys


BUGREPORT_PATH=/data/user_de/0/com.android.shell/files/bugreports

#BUSYBOX=busybox

# check boot complete
android_boot=`getprop sys.boot_completed`

if [ "$android_boot" == "" || "$android_boot" == "0"]; then
	echo "boot not ready !!"
	exit
fi

# Workaround - permissive
#echo asussetenforce:0 > /proc/rd

savelogs_prop=`getprop persist.asus.savelogs`
is_tcpdump_status=`getprop init.svc.tcpdump-warp`
isBetaUser=`getprop persist.asus.mupload.enable`

echo "P1"

save_general_log() {
	############################################################################################
	# save cmdline
	cat /proc/cmdline > $GENERAL_LOG/cmdline.txt
	echo "cat /proc/cmdline > $GENERAL_LOG/cmdline.txt"	
	############################################################################################
	# save mount table
	cat /proc/mounts > $GENERAL_LOG/mounts.txt
	echo "cat /proc/mounts > $GENERAL_LOG/mounts.txt"
	############################################################################################
	getenforce > $GENERAL_LOG/getenforce.txt
	echo "getenforce > $GENERAL_LOG/getenforce.txt"
	############################################################################################
	# save property
	getprop > $GENERAL_LOG/getprop.txt
	echo "getprop > $GENERAL_LOG/getprop.txt"
	############################################################################################
	# save network info
	cat /proc/net/route > $GENERAL_LOG/route.txt
	echo "cat /proc/net/route > $GENERAL_LOG/route.txt"
	ifconfig -a > $GENERAL_LOG/ifconfig.txt
	echo "ifconfig -a > $GENERAL_LOG/ifconfig.txt"
	############################################################################################
	# save software version
	echo "AP_VER: `getprop ro.build.display.id`" > $GENERAL_LOG/version.txt
	echo "CP_VER: `getprop gsm.version.baseband`" >> $GENERAL_LOG/version.txt
	echo "BT_VER: `getprop bt.version.driver`" >> $GENERAL_LOG/version.txt
	echo "WIFI_VER: `getprop wifi.version.driver`" >> $GENERAL_LOG/version.txt
	echo "GPS_VER: `getprop gps.version.driver`" >> $GENERAL_LOG/version.txt
	echo "BUILD_DATE: `getprop ro.build.date`" >> $GENERAL_LOG/version.txt
	############################################################################################
	# save load kernel modules
	lsmod > $GENERAL_LOG/lsmod.txt
	echo "lsmod > $GENERAL_LOG/lsmod.txt"
	############################################################################################
	# save process now
	ps -eo f,s,uid,pid,ppid,c,pri,ni,bit,sz,%mem,%cpu,wchan,tty,time,cmd > $GENERAL_LOG/ps.txt
	echo "ps > $GENERAL_LOG/ps.txt"
	ps -A -T > $GENERAL_LOG/ps_thread.txt
	echo "ps > $GENERAL_LOG/ps_thread.txt"
	############################################################################################
	# save kernel message - dmesg move to debug_info.sh
	start asus_debug_info
	############################################################################################
	# copy data/log to data/media
	#$BUSYBOX ls -R -l /data/log/ > $GENERAL_LOG/ls_data_log.txt
	#mkdir $GENERAL_LOG/log
	#$BUSYBOX cp /data/log/* $GENERAL_LOG/log/
	#echo "$BUSYBOX cp /data/log $GENERAL_LOG"
	############################################################################################
	# copy data/tombstones to data/media
	ls -R -l /data/tombstones/ > $GENERAL_LOG/ls_data_tombstones.txt
	mkdir $GENERAL_LOG/tombstones
	cp -r /data/tombstones/* $GENERAL_LOG/tombstones/
	echo "cp /data/tombstones $GENERAL_LOG"
	rm -rf /data/tombstones/*
	############################################################################################
	ls -R -lZa /asdf > $GENERAL_LOG/ls_asdf.txt
	############################################################################################
	# copy data/tombstones to data/media
	#busybox ls -R -l /tombstones/mdm > $SAVE_LOG_PATH/GENERAL_LOG.txt
	mkdir -p /data/tombstones/dsps
	mkdir -p /data/tombstones/lpass
	mkdir -p /data/tombstones/mdm
	mkdir -p /data/tombstones/modem
	mkdir -p /data/tombstones/wcnss
	chown system.system /data/tombstones/*
	chmod 771 /data/tombstones/*
	############################################################################################
	# copy Debug Ion information to data/media
	mkdir $GENERAL_LOG/ION_Debug
	cp -r /d/ion/* $GENERAL_LOG/ION_Debug/
	############################################################################################
	# copy data/logcat_log to data/media
	#busybox ls -R -l /data/logcat_log/ > $GENERAL_LOG/ls_data_logcat_log.txt
	#$BUSYBOX cp -r /data/logcat_log/ $GENERAL_LOG
	#echo "$BUSYBOX cp -r /data/logcat_log $GENERAL_LOG"
	mkdir $GENERAL_LOG/logcat_log
	# logcat & radio
	if [ -d "/data/logcat_log" ]; then
		for x in logcat logcat-kernel logcat-other logcat-radio logcat-events
		do
			cp /data/logcat_log/$x.txt /data/logcat_log/$x.txt.0
			cp /data/logcat_log/$x.txt.* $GENERAL_LOG/logcat_log
		done
		rm /data/logcat_log/logcat-kernel.txt.*
		rm /data/logcat_log/logcat-other.txt.*
		rm /data/logcat_log/logcat.txt.*
		rm /data/logcat_log/logcat-radio.txt.*
		rm /data/logcat_log/logcat-events.txt.*
	fi
	############################################################################################
	# copy recovery log to data/media
	if [ -d "/cache/recovery/" ]; then
		ls -R -l /cache/recovery > $GENERAL_LOG/ls_cache_recovery.txt
		mkdir $GENERAL_LOG/cache_recovery
		cp -r /cache/recovery/* $GENERAL_LOG/cache_recovery/
		echo "cp -r /cache/recovery/ $GENERAL_LOG"/cache_recovery/
	fi	
	############################################################################################
	# copy /asdf/ASUSEvtlog.txt to ASDF
	cp -r /sdcard/asus_log/ASUSEvtlog.txt $GENERAL_LOG #backward compatible
	cp -r /sdcard/asus_log/ASUSEvtlog_old.txt $GENERAL_LOG #backward compatible
	cp -r /asdf/ASUSEvtlog.txt $GENERAL_LOG
	cp -r /asdf/ASUSEvtlog_old.txt $GENERAL_LOG
	cp -r /asdf/ASDF $GENERAL_LOG
	rm -r /asdf/ASDF/ASDF.*
	cp -r /asdf/dumpsys_meminfo $GENERAL_LOG && rm -r /asdf/dumpsys_meminfo
	echo "cp -r /asdf/ASUSEvtlog.txt $GENERAL_LOG"
	############################################################################################
	# copy /asdf/asdf-logcat.txt
	cp /asdf/asdf-logcat.* $SAVE_LOG_PATH/logcat_log
	echo "cp /asdf/asdf-logcat.txt $GENERAL_LOG/logcat_log"
	############################################################################################
	# copy /sdcard/wlan_logs/
	cp -r /sdcard/wlan_logs/cnss_fw_logs_current.txt $GENERAL_LOG
	echo "cp -r /sdcard/wlan_logs/cnss_fw_logs_current.txt $GENERAL_LOG"
	############################################################################################
	if [ ".$isBetaUser" == ".1" ]; then
		cp -r /data/misc/wifi/WifiConfigStore.xml $GENERAL_LOG
		echo "cp -r /data/misc/wifi/WifiConfigStore.xml $GENERAL_LOG"
		# copy /data/misc/wifi/wpa_supplicant.conf
		# copy /data/misc/wifi/hostapd.conf
		# copy /data/misc/wifi/p2p_supplicant.conf
		ls -R -l /data/misc/wifi/ > $GENERAL_LOG/ls_wifi_asus_log.txt
		cp -r /data/misc/wifi/wpa_supplicant.conf $GENERAL_LOG
		echo "cp -r /data/misc/wifi/wpa_supplicant.conf $GENERAL_LOG"
		cp -r /data/misc/wifi/hostapd.conf $GENERAL_LOG
		echo "cp -r /data/misc/wifi/hostapd.conf $GENERAL_LOG"
		cp -r /data/misc/wifi/p2p_supplicant.conf $GENERAL_LOG
		echo "cp -r /data/misc/wifi/p2p_supplicant.conf $GENERAL_LOG"
	fi
	############################################################################################
	# mv /data/anr to data/media
	ls -R -lZ /data/anr > $GENERAL_LOG/ls_data_anr.txt
	mkdir $GENERAL_LOG/anr
	cp -r /data/anr/* $GENERAL_LOG/anr/
	rm -r /data/anr/*
	echo "cp /data/anr $GENERAL_LOG"
	############################################################################################
	# save system information
	mkdir $DUMPSYS_DIR
    for x in SurfaceFlinger window activity input_method alarm power battery batterystats; do
        dumpsys $x > $DUMPSYS_DIR/$x.txt
        echo "dumpsys $x > $DUMPSYS_DIR/$x.txt"
    done
	############################################################################################
	# emmc r/w record
	echo "uptime" > $GENERAL_LOG/emmc_rw_record.txt
	uptime >> $GENERAL_LOG/emmc_rw_record.txt
	echo "/sys/block/mmcblk0/stat" >> $GENERAL_LOG/emmc_rw_record.txt
	cat /sys/block/mmcblk0/stat >> $GENERAL_LOG/emmc_rw_record.txt
	echo "emmc r/w record in $GENERAL_LOG/emmc_rw_record.txt"
    ############################################################################################
    # [BugReporter]Save ps.txt to Dumpsys folder
    #ps -t -p -P > $DUMPSYS_DIR/ps.txt
    ps -o "USER,PID,PPID,VSZ,ADDR,RSS,PRI,NICE,RTPRIO,SCHED,PCY,WCHAN,C,NAME" > $DUMPSYS_DIR/ps.txt
    ############################################################################################
    date > $GENERAL_LOG/date.txt
	echo "date > $GENERAL_LOG/date.txt"
	############################################################################################
    # No MicroP
	#micropTest=`cat /sys/class/switch/pfs_pad_ec/state`
	#if [ "${micropTest}" = "1" ]; then
	#    date > $GENERAL_LOG/microp_dump.txt
	#    cat /d/gpio >> $GENERAL_LOG/microp_dump.txt                   
    #    echo "cat /d/gpio > $GENERAL_LOG/microp_dump.txt"  
    #    cat /d/microp >> $GENERAL_LOG/microp_dump.txt
    #    echo "cat /d/microp > $GENERAL_LOG/microp_dump.txt"
	#fi
	############################################################################################
	df > $GENERAL_LOG/df.txt
	echo "df > $GENERAL_LOG/df.txt"
	start asusdumpstate
}

save_modem_log() {
	mv /data/media/diag_logs/QXDM_logs $MODEM_LOG 
	echo "mv /data/media/diag_logs/QXDM_logs $MODEM_LOG"
}

save_tcpdump_log() {
	if [ -d "/data/logcat_log" ]; then
		if [ ".$is_tcpdump_status" == ".running" ]; then
			stop tcpdump-warp
			mv /data/logcat_log/capture.pcap0 /data/logcat_log/capture.pcap0-1
			start tcpdump-warp
			for fname in /data/logcat_log/capture.pcap*
			do
				if [ -e $fname ]; then
					if [ ".$fname" != "./data/logcat_log/capture.pcap0" ]; then
						mv $fname $TCP_DUMP_LOG
					fi
				fi
			done
		else
			mv /data/logcat_log/capture.pcap* $TCP_DUMP_LOG
		fi
	fi
}

remove_folder() {
	# remove folder
	if [ -e $GENERAL_LOG ]; then
		rm -r $GENERAL_LOG
	fi
	
	if [ -e $MODEM_LOG ]; then
		rm -r $MODEM_LOG
	fi
	
	if [ -e $TCP_DUMP_LOG ]; then
		rm -r $TCP_DUMP_LOG
	fi

	if [ -e $DUMPSYS_DIR ]; then
		rm -r $DUMPSYS_DIR
	fi
	
	if [ -e $BUGREPORT_PATH ]; then
		rm -r $BUGREPORT_PATH
	fi
}


create_folder() {
	# create folder
	mkdir -p $GENERAL_LOG
	echo "mkdir -p $GENERAL_LOG"
	
	mkdir -p $MODEM_LOG
	echo "mkdir -p $MODEM_LOG"
	
	mkdir -p $TCP_DUMP_LOG
	echo "mkdir -p $GENERAL_LOG"
	
	mkdir -p $BUGREPORT_PATH
	echo "mkdir -p $BUGREPORT_PATH"
}

if [ ".$savelogs_prop" == ".0" ]; then
	echo "P2"
	remove_folder
    setprop persist.asus.uts com.asus.removelogs.completed
    setprop persist.asus.savelogs.complete 0
    setprop persist.asus.savelogs.complete 1
#	am broadcast -a "com.asus.removelogs.completed"
elif [ ".$savelogs_prop" == ".1" ]; then
	echo "P3"
	# check mount file
	umask 0;
	sync
	############################################################################################
	# remove folder
	remove_folder

	# create folder
	create_folder
	
	# save_general_log
	save_general_log
	
	############################################################################################
	# sync data to disk 
	# 1015 sdcard_rw
	#chmod -R 777 $GENERAL_LOG
	#sync

#    setprop persist.asus.uts com.asus.savelogs.completed
#    setprop persist.asus.savelogs.complete 0
#    setprop persist.asus.savelogs.complete 1
	#am broadcast -a "com.asus.savelogs.completed"
 
	echo "Done"
elif [ ".$savelogs_prop" == ".2" ]; then
	echo "P4"
	# check mount file
	umask 0;
	sync
	############################################################################################
	# remove folder
	remove_folder

	# create folder
	create_folder
	
	# save_modem_log
	save_modem_log
	
	############################################################################################
	# sync data to disk 
	# 1015 sdcard_rw
	chmod -R 777 $MODEM_LOG
	sync

    setprop persist.asus.uts com.asus.savelogs.completed
    setprop persist.asus.savelogs.complete 0
    setprop persist.asus.savelogs.complete 1
	#am broadcast -a "com.asus.savelogs.completed"
 
	echo "Done"
elif [ ".$savelogs_prop" == ".3" ]; then
	echo "P5"
	# check mount file
	umask 0;
	sync
	############################################################################################
	# remove folder
	remove_folder

	# create folder
	create_folder
	
	# save_tcpdump_log
	save_tcpdump_log
	
	############################################################################################
	# sync data to disk 
	# 1015 sdcard_rw
	chmod -R 777 $TCP_DUMP_LOG
	sync

    setprop persist.asus.uts com.asus.savelogs.completed
    setprop persist.asus.savelogs.complete 0
    setprop persist.asus.savelogs.complete 1
#	am broadcast -a "com.asus.savelogs.completed"
 
	echo "Done"
elif [ ".$savelogs_prop" == ".4" ]; then
	echo "P6"
	# check mount file
	umask 0;
	sync
	############################################################################################
	# remove folder
	remove_folder

	# create folder
	create_folder
	
	# save_general_log
	save_general_log
	
	# save_modem_log
	save_modem_log
	
	# save_tcpdump_log
	save_tcpdump_log
	
	############################################################################################
	# sync data to disk 
	# 1015 sdcard_rw
	# chmod -R 777 $GENERAL_LOG
	chmod -R 777 $MODEM_LOG
	chmod -R 777 $TCP_DUMP_LOG
#    setprop persist.asus.uts com.asus.savelogs.completed
#    setprop persist.asus.savelogs.complete 0
#    setprop persist.asus.savelogs.complete 1
#    am broadcast -a "com.asus.savelogs.completed"
fi
