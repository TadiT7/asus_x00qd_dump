#!/system/bin/sh

ON="/proc/driver/ois_power"
RC="/proc/driver/ois_atd_status"
FW="/proc/driver/ois_fw_update"

LOG="/proc/fac_printklog"

function cat_status()
{
        cat $RC
}
function power_on()
{
        echo 1 > $ON
}
function power_off()
{
        echo 0 > $ON
}

[ -e $LOG ] && echo "$0 $*"> $LOG

output=$(cat $ON)
if [ $output -eq 0 ]
then
        echo "Solo power up..."
        solo=1
        power_on

        vcm=`cat /proc/driver/rear_otp_vcm`
        echo 0 0 $vcm > $FW
else
        solo=0
fi

if [ $solo -eq 1 ]
then
        echo "Solo power down..."
        power_off
fi

