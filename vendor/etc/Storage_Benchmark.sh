#!/system/bin/sh
app=`getprop sys.storage.bchmode`
echo "onFgAPP is $app"

if [ $app != "0" ]; then
	echo "set 1"
	echo 1 > sys/devices/system/cpu/cpufreq/policy0/interactive/io_is_busy
	echo 1 > sys/devices/system/cpu/cpufreq/policy4/interactive/io_is_busy
else
	echo "set 0"
	echo 0 > sys/devices/system/cpu/cpufreq/policy0/interactive/io_is_busy
	echo 0 > sys/devices/system/cpu/cpufreq/policy4/interactive/io_is_busy
fi

if [ $app != "com.a1dev.sdbench" ];then
	echo 20 > /proc/sys/vm/dirty_ratio
else
	echo 1 > /proc/sys/vm/dirty_ratio
fi

