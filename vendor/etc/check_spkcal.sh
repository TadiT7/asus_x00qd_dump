#!/system/bin/sh

check_audio_calibration=`getprop tfa9874.spk.calibration`

echo "[ASUS][SpeakerCalibration] Begin Check Speaker calibration status" > /dev/kmsg
log -p d -t [ASUS][SpeakerCalibration] Begin Check Speaker calibration status
echo "[ASUS][SpeakerCalibration] Check Speaker calibration status tfa9874.spk.calibration = $check_audio_calibration" > /dev/kmsg
log -p d -t [ASUS][SpeakerCalibration] Check Speaker calibration status tfa9874.spk.calibration = $check_audio_calibration

if [ "${check_audio_calibration}" != "pass" ];
	then
	echo "[ASUS][SpeakerCalibration] Without Speaker calibration property" > /dev/kmsg
	log -p d -t [ASUS][SpeakerCalibration] Without Speaker calibration property

	if [ ! -f "/factory/cal_s_speaker0_log.txt" ];then
		echo "[ASUS][SpeakerCalibration] Original /factory/cal_s_speaker0_log.txt does not exist" > /dev/kmsg
		log -p d -t [ASUS][SpeakerCalibration] Original /factory/cal_s_speaker0_log.txt does not exist
	else
		check_audio_calibration_data=$(cat /factory/cal_s_speaker0_log.txt)
		echo "[ASUS][SpeakerCalibration] Original /factory/cal_s_speaker0_log.txt = $check_audio_calibration_data" > /dev/kmsg
		log -p d -t [ASUS][SpeakerCalibration] Original /factory/cal_s_speaker0_log.txt = $check_audio_calibration_data
	fi

	if [ ! -f "/asusfw/audio/cal_self_speaker0_log.txt" ];then
		echo "[ASUS][SpeakerCalibration] Without asusfw Speaker calibration data, begin calibration again" > /dev/kmsg
		log -p d -t [ASUS][SpeakerCalibration] Without Speaker calibration data, begin calibration again

		sleep 1

		Temp_data=`climax -dsysfs -l /vendor/firmware/stereo.cnt --resetmtpex`
		echo $Temp_data > /asusfw/audio/cal_self_recal_speaker0_log_tmp.txt

		Temp_data=`climax -dsysfs -l /vendor/firmware/stereo.cnt --calibrate=once`
		echo $Temp_data > /asusfw/audio/cal_self_speaker0_log_tmp.txt

		Temp_data=`climax -d /dev/i2c-6 --slave=0x35 -r 0xf5`
		echo $Temp_data > /asusfw/audio/cal_self_receiver0_data_tmp.txt
		SpeakerCalibrationTest 5 > /dev/null
	else
		check_audio_calibration_data=$(cat /asusfw/audio/cal_self_speaker0_log.txt)
		if [ "${check_audio_calibration_data}" == "0" ];
			then
			echo "[ASUS][SpeakerCalibration] Self calibration begin" > /proc/asusevtlog

			echo "[ASUS][SpeakerCalibration] /asusfw/audio/cal_self_speaker0_log.txt = $check_audio_calibration_data still need calibration" > /dev/kmsg
			log -p d -t [ASUS][SpeakerCalibration] /asusfw/audio/cal_self_speaker0_log.txt = $check_audio_calibration_data  still need calibration


			echo 0 > /asusfw/audio/0x34_aftercalmtp.txt
			echo 0 > /asusfw/audio/0x34_origmtp.txt
			echo 0 > /asusfw/audio/0x35_aftercalmtp.txt
			echo 0 > /asusfw/audio/0x35_origmtp.txt
			echo 0 > /asusfw/audio/spkcal_save_0x34_aftercalmtp.txt
			echo 0 > /asusfw/audio/spkcal_save_0x34_origmtp.txt
			echo 0 > /asusfw/audio/spkcal_save_0x35_aftercalmtp.txt
			echo 0 > /asusfw/audio/spkcal_save_0x35_origmtp.txt


			echo "[ASUS][SpeakerCalibration] Speaker Begin calibrated" > /dev/kmsg
			log -p d -t [ASUS][SpeakerCalibration] Speaker Begin calibrated

			Temp_data=`climax -dsysfs -l /vendor/firmware/stereo.cnt --resetmtpex -b`
			echo "$Temp_data" > /asusfw/audio/cal_self_recal_speaker0_log_tmp.txt

			echo "[ASUS][SpeakerCalibration] Speaker Begin resetmtpex = $Temp_data" > /dev/kmsg
			log -p d -t [ASUS][SpeakerCalibration] Speaker Begin resetmtpex = "$Temp_data"

			sleep 1

			Temp_data=`climax -dsysfs -l /vendor/firmware/stereo.cnt --calibrate=once -b`
			echo "$Temp_data" > /asusfw/audio/cal_self_speaker0_log_tmp.txt

			echo "[ASUS][SpeakerCalibration] Speaker Begin calibrated = $Temp_data" > /dev/kmsg
			log -p d -t [ASUS][SpeakerCalibration] Speaker Begin calibrated = "$Temp_data"

			sleep 1

			Temp_data=`climax -d /dev/i2c-6 --slave=0x35 -r 0xf5`
			echo $Temp_data > /asusfw/audio/cal_self_speaker0_data_tmp.txt

			echo "[ASUS][SpeakerCalibration] Speaker calibrated result = $Temp_data" > /dev/kmsg
			log -p d -t [ASUS][SpeakerCalibration] Speaker calibrated result = $Temp_data

			cp /asusfw/audio/0x34_aftercalmtp.txt /asusfw/audio/spkcal_save_0x34_aftercalmtp.txt
			cp /asusfw/audio/0x34_origmtp.txt /asusfw/audio/spkcal_save_0x34_origmtp.txt
			cp /asusfw/audio/0x35_aftercalmtp.txt /asusfw/audio/spkcal_save_0x35_aftercalmtp.txt
			cp /asusfw/audio/0x35_origmtp.txt /asusfw/audio/spkcal_save_0x35_origmtp.txt

			SpeakerCalibrationTest 5 > /dev/null
		else
			echo "[ASUS][SpeakerCalibration] /asusfw/audio/cal_self_speaker0_log.txt = $check_audio_calibration_data" > /dev/kmsg
			log -p d -t [ASUS][SpeakerCalibration] /asusfw/audio/cal_self_speaker0_log.txt = $check_audio_calibration_data
		fi
	fi

else
	echo "[ASUS][SpeakerCalibration] Speaker already calibrated" > /dev/kmsg
	log -p d -t [ASUS][SpeakerCalibration] Speaker already calibrated
fi
