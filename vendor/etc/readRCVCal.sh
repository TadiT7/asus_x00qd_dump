#!/system/bin/sh
if [ "$1" == "0" -o "$1" == "1" ]; then
    cat /factory/cal_s_receiver$1_log.txt
fi
