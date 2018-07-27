#!/system/bin/sh

check_audio_calibration=`getprop tfa9874.rcv.calibration`

echo "[ASUS][ReceiverCalibration] Begin Check Receiver calibration status" > /dev/kmsg
log -p d -t [ASUS][ReceiverCalibration] Begin Check Receiver calibration status

echo "[ASUS][ReceiverCalibration] Check Receiver calibration status tfa9874.rcv.calibration = $check_audio_calibration" > /dev/kmsg
log -p d -t [ASUS][ReceiverCalibration] Check Receiver calibration status tfa9874.rcv.calibration = $check_audio_calibration

if [ "${check_audio_calibration}" != "pass" ];
	then
	echo "[ASUS][ReceiverCalibration] Without Receiver calibration property" > /dev/kmsg
	log -p d -t [ASUS][ReceiverCalibration] Without Receiver calibration property

	if [ ! -f "/factory/cal_s_receiver0_log.txt" ];then
		echo "[ASUS][ReceiverCalibration] Original /factory/cal_s_receiver0_log.txt does not exist" > /dev/kmsg
		log -p d -t [ASUS][ReceiverCalibration] Original /factory/cal_s_receiver0_log.txt does not exist
	else
		check_audio_calibration_data=$(cat /factory/cal_s_receiver0_log.txt)
		echo "[ASUS][ReceiverCalibration] Original /factory/cal_s_receiver0_log.txt = $check_audio_calibration_data" > /dev/kmsg
		log -p d -t [ASUS][ReceiverCalibration] Original /factory/cal_s_receiver0_log.txt = $check_audio_calibration_data
	fi

	if [ ! -f "/asusfw/audio/cal_self_receiver0_log.txt" ];then
		echo "[ASUS][ReceiverCalibration] Without asusfw Receiver calibration data, begin calibration again" > /dev/kmsg
		log -p d -t [ASUS][ReceiverCalibration] Without Receiver calibration data, begin calibration again
		Temp_data=`climax -d /dev/i2c-6 --slave=0x34 -r 0xf5`
		echo $Temp_data > /asusfw/audio/cal_self_receiver0_data_tmp.txt
		ReceiverCalibrationTest 5 > /dev/null
	else
		check_audio_calibration_data=$(cat /asusfw/audio/cal_self_receiver0_log.txt)
		if [ "${check_audio_calibration_data}" == "0" ];
			then
			echo "[ASUS][ReceiverCalibration] /asusfw/audio/cal_self_receiver0_log.txt = $check_audio_calibration_data still need calibration" > /dev/kmsg
			log -p d -t [ASUS][ReceiverCalibration] /asusfw/audio/cal_self_receiver0_log.txt = $check_audio_calibration_data still need calibration
			Temp_data=`climax -d /dev/i2c-6 --slave=0x34 -r 0xf5`
			echo $Temp_data > /asusfw/audio/cal_self_receiver0_data_tmp.txt
			ReceiverCalibrationTest 5 > /dev/null

		else
			echo "[ASUS][ReceiverCalibration] /asusfw/audio/cal_self_receiver0_log.txt = $check_audio_calibration_data" > /dev/kmsg
			log -p d -t [ASUS][ReceiverCalibration] /asusfw/audio/cal_self_receiver0_log.txt = $check_audio_calibration_data
		fi
	fi

else
	echo "[ASUS][ReceiverCalibration] Receiver already calibrated" > /dev/kmsg
	log -p d -t [ASUS][ReceiverCalibration] Receiver already calibrated
fi
