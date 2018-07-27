#!/system/bin/sh
filepath="/sys/block/mmcblk1/size"
if [ -e $filepath ];then
    echo 1
else
    echo 0
fi

#touch mnt/media_rw/MicroSD
#touch /Removable
#chmod 777 /data/data/sd_status
