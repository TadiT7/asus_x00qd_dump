#!/system/bin/sh
list=(
'com.quicinc.vellamo' 
'com.andromeda.androbench2' 
'com.a1dev.sdbench' 
'com.futuremark.pcmark.android.benchmark' 
)

checklist()
{
i=0
while [ $i -ne ${#list[@]} ]
do

	if [ ${list[$i]} = $1 ]; then
		echo 1
		return
	fi	
	((i++))
done

echo 0
return
}

#app=`getprop sys.storage.bchmode`
app=`getprop sys.foregroundapp`
#echo "onFgAPP is $app"
result=`checklist $app`
#echo $result
if [ $result != "0" ]; then
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

