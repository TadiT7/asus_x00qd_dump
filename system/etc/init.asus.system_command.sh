#!/system/bin/sh

export PATH=/system/bin
THERMAL_DUMPSYS=`getprop sys.thermal.dumpsys`
if [ "$THERMAL_DUMPSYS" == "1" ]; then
    dumpsys sensorservice | grep -A50 'active connection' >> /data/logcat_log/logcat.txt
    /vendor/bin/sns_dump_pm
    setprop sys.thermal.dumpsys 0
fi
