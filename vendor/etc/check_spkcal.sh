#!/system/bin/sh

check_audio_calibration=`getprop tfa9874.spk.calibration`

echo "[ASUS][Audio] Begin Check Speaker calibration status" > /dev/kmsg
log -p d -t [ASUS][Audio] Begin Check Speaker calibration status
echo "[ASUS][Audio] Check Speaker calibration status tfa9874.rcv.calibration = $check_audio_calibration" > /dev/kmsg
log -p d -t [ASUS][Audio] Check Speaker calibration status tfa9874.spk.calibration = $check_audio_calibration

if [ "${check_audio_calibration}" != "pass" ];
	then
	echo "[ASUS][Audio] Without Speaker calibration property" > /dev/kmsg
	log -p d -t [ASUS][Audio] Without Speaker calibration property

	if [ ! -f "/factory/cal_s_speaker0_log.txt" ];then
		if [ ! -f "/data/data/cal_s_speaker0_log.txt" ];then
			echo "[ASUS][Audio] Without Speaker calibration data, begin calibration again" > /dev/kmsg
			log -p d -t [ASUS][Audio] Without Speaker calibration data, begin calibration again
			SpeakerCalibrationTest 5 > /dev/null
		else
			check_audio_calibration_data=$(cat /data/data/cal_s_speaker0_log.txt)
			echo "[ASUS][Audio] /data/data/cal_s_speaker0_log.txt = $check_audio_calibration_data" > /dev/kmsg
			log -p d -t [ASUS][Audio] /data/data/cal_s_speaker0_log.txt = $check_audio_calibration_data
		fi
	else
		check_audio_calibration_data=$(cat /factory/cal_s_speaker0_log.txt)
		echo "[ASUS][Audio] /factory/cal_s_speaker0_log.txt = $check_audio_calibration_data" > /dev/kmsg
		log -p d -t [ASUS][Audio] /factory/cal_s_speaker0_log.txt = $check_audio_calibration_data
	fi

else
	echo "[ASUS][Audio] Speaker already calibrated" > /dev/kmsg
	log -p d -t [ASUS][Audio] Speaker already calibrated
fi
