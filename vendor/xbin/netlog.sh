#!/system/bin/sh

sfile=`getprop sys.tcpdump.file`
size=`getprop sys.tcpdump.size`
num=`getprop sys.tcpdump.num`

if [ "$sfile" == "" ]; then
	echo "property sys.tcpdump.file is not exist"
	sfile="/data/logcat_log/capture.pcap"
fi

if [ "$size" == "" ]; then
	echo "property sys.tcpdump.size is not exist"
	size="20"
fi

if [ "$num" == "" ]; then
	echo "property sys.tcpdump.num is not exist"
	num="2"
fi

netlog -i any -p -s 0 -Z root -C $size -W $num -w $sfile
