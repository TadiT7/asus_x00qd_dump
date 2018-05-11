#!/system/vendor/bin/sh
LIB_PATH="/system/vendor/lib/"
VENDOR_LIB_PATH="/system/vendor/lib/"
DataSetarch_PATH="/system/vendor/lib/DataSet/arch/"
DataSetditSCidGen_PATH="/system/vendor/lib/DataSet/ditSCidGen/"
DataSetDB_PATH="/system/vendor/lib/DataSet/ispDB/"
BIN_PATH="/system/vendor/bin/"
#/system/vendor/lib
DIT_FILE1="libxditk_ditArchLIB"
DIT_FILE2="libxditk_arch"
DIT_FILE3="libxditk_DIT_Manager"
DIT_FILE4="libxditk_DIT_MSMv1"
DIT_FILE5="libxditk_ditBSP_JNI"
DIT_FILE6="libxditk_ISP"
DIT_FILE7="libxditk_ditBSP"
#/system/vendor/lib
DIT_FILE51="libchromatix_imx362_cpp_default_factory"
DIT_FILE52="libchromatix_imx362_isp_default_factory"
DIT_FILE53="libchromatix_imx362_common_default"
DIT_FILE54="libchromatix_ov8856_8501_cpp_default_factory"
DIT_FILE55="libchromatix_ov8856_8501_isp_default_factory"
DIT_FILE56="libchromatix_ov8856_8501_common_default"
DIT_FILE57="libchromatix_ov8856_gs8837_cpp_default_factory"
DIT_FILE58="libchromatix_ov8856_gs8837_isp_default_factory"
DIT_FILE59="libchromatix_ov8856_gs8837_common_default"
#/system/vendor/lib/DataSet/ditSCidGen/
DIT_FILE21="msgchk"
#/system/vendor/lib/DataSet/ispDB/
DIT_FILE22="ParameterDB"
#/system/vendor/bin/
DIT_FILE26="dit"
DIT_FILE27="dit_af"
DIT_FILE28="test_af"
DIT_FILE29="dit_ae"
DIT_FILE30="test_ae"
FILE_EXTENSION1=".so"
FILE_EXTENSION2=".cfg"
FILE_EXTENSION3=".db"
FILE_EXTENSION4="CalibrationData"
FILE_EXTENSION5="_cali"
FILE_EXTENSION6="_cali_golden"
FILE_EXTENSION7="_ID"
FILE_EXTENSION8="CaliDB"
FILE_EXTENSION9="Cali"
DITFW_PATH="/data/DIT_fw/"
RETRY_COUNT=50
INDEX=0
FINISH_RESULT_FILE="finished_result"
FINISH_RESULT="all file modify path completed"
SINGLE_FINISH_RESULT="file_modify_path completed"
NEED_REMOUNT_RESULT="need remount system"
DITFWLOG_PATH="/data/logcat_log/"

file_modify_path()
{
	modify_result=$(cat $4$2$3"_completed" 2> /dev/null|tr -d '\r')
	if [ -L $1$2$3 ] && [ "$modify_result" == "$SINGLE_FINISH_RESULT" -a -s $4$2$3 ];
	then
		echo "$4$2$3 $SINGLE_FINISH_RESULT" >> $DITFWLOG_PATH"DITinit_log"
		return 0
	fi
	if [ -s $1$2"_org"$3 ];
	then
		#BSP PJ_Ma +++ "always deleted DIT_FILE those copy from original"
		#TMP_NAME1=$(ls -l $1$2"_org"$3|awk {'print $5'})
		#TMP_NAME2=$(ls -l $4$2$3|awk {'print $5'})
		#echo "$TMP_NAME1 $TMP_NAME2" >> $DITFWLOG_PATH"DITinit_log"
		#if [ $TMP_NAME1 = $TMP_NAME2 ];
		#then
		rm -rf $4$2$3
		#fi
		#BSP PJ_Ma --- "always deleted DIT_FILE those copy from original"
		#echo "File $1$2_org$3 exists" >> $DITFWLOG_PATH"DITinit_log"
		if [ -s $4$2$3 ];
		then
			#echo "File $4$2$3 exists" >> $DITFWLOG_PATH"DITinit_log"
			rm -rf $1$2$3
			ln -s $4$2$3 $1$2$3
			chmod 644 $1$2$3
			chown root:root $1$2$3
		else
			#echo "File $4$2$3 does not exists" >> $DITFWLOG_PATH"DITinit_log"
			echo "$4$2$3 file size is zero/not_exist so remove it" >> $DITFWLOG_PATH"DITinit_log"
			rm -rf $4$2$3
			INDEX=0
			while [ $INDEX -lt $RETRY_COUNT ];
			do
				cp $1$2"_org"$3 $4$2$3
				touch $1$2"_org"$3
				if [ -s $4$2$3 ];
				then
					break
				else
					echo "$4$2$3 file size is zero so remove it" >> $DITFWLOG_PATH"DITinit_log"
					rm -rf $4$2$3
					INDEX=$(($INDEX+1))
				fi
			done
			if [ -s $4$2$3 ];
			then
				echo "$4$2$3 file size is ok"
				rm -rf $1$2$3
			else
				echo "$4$2$3 file size still is zero after retry so exit" >> $DITFWLOG_PATH"DITinit_log"
				rm -rf $4$2$3
				return 0
			fi
			ln -s $4$2$3 $1$2$3
			chmod 644 $1$2$3
			chown root:root $1$2$3	
		fi
	else
		#echo "File $1$2_org$3 does not exists" >> $DITFWLOG_PATH"DITinit_log"
		if [ -s $1$2$3 ];
		then
			echo "$1$2$3 file size is ok"
		else
			echo "$1$2$3 file size is zero so Camera may can't open" >> $DITFWLOG_PATH"DITinit_log"
			return 0
		fi
		INDEX=0
		while [ $INDEX -lt $RETRY_COUNT ];
		do
			mv $1$2$3 $1$2"_org"$3
			touch $1$2"_org"$3
			if [ -s $1$2"_org"$3 ];
			then
				break
			else
				echo "$1$2_org$3 file size is zero so remove it,now INDEX $INDEX" >> $DITFWLOG_PATH"DITinit_log"
				rm -rf $1$2"_org"$3
				INDEX=$(($INDEX+1))
				sleep 0.01
			fi
		done
		if [ -s $1$2"_org"$3 ];
		then
			echo "$1$2_org$3 file size is ok"
		else
			echo "$1$2_org$3 file size still is zero after retry so exit" >> $DITFWLOG_PATH"DITinit_log"
			rm -rf $1$2"_org"$3
			return 0
		fi
		if [ -s $4$2$3 ];
		then
			#echo "File $4$2$3 exists" >> $DITFWLOG_PATH"DITinit_log"
			rm -rf $1$2$3
			ln -s $4$2$3 $1$2$3
			chmod 644 $1$2$3
			chown root:root $1$2$3
		else
			#echo "File $4$2$3 does not exists" >> $DITFWLOG_PATH"DITinit_log"
			echo "$4$2$3 file size is zero/not_exist so remove it" >> $DITFWLOG_PATH"DITinit_log"
			rm -rf $4$2$3
			INDEX=0
			while [ $INDEX -lt $RETRY_COUNT ];
			do
				cp $1$2"_org"$3 $4$2$3
				touch $1$2"_org"$3
				if [ -s $4$2$3 ];
				then
					break
				else
					echo "$4$2$3 file size is zero so remove it,now INDEX $INDEX" >> $DITFWLOG_PATH"DITinit_log"
					rm -rf $4$2$3
					INDEX=$(($INDEX+1))
					sleep 0.01
				fi
			done
			if [ -s $4$2$3 ];
			then
				echo "$4$2$3 file size is ok"
				rm -rf $1$2$3
			else
				echo "$4$2$3 file size still is zero after retry so exit" >> $DITFWLOG_PATH"DITinit_log"
				rm -rf $4$2$3
				return 0
			fi
			ln -s $4$2$3 $1$2$3
			chmod 644 $1$2$3
			chown root:root $1$2$3
		fi
	fi
	if [ $1 = $BIN_PATH ];
	then
		chmod 755 $4$2$3
		chown root:shell $4$2$3	
	fi
	echo $SINGLE_FINISH_RESULT > $4$2$3"_completed"
	chmod 666 $4$2$3"_completed"
}
check_file_modify_path_finished()
{
	stop cameraserver
	mount -o rw,remount /system
	file_modify_path $LIB_PATH $DIT_FILE1 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $LIB_PATH $DIT_FILE2 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $LIB_PATH $DIT_FILE3 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $LIB_PATH $DIT_FILE4 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $LIB_PATH $DIT_FILE5 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $LIB_PATH $DIT_FILE6 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $LIB_PATH $DIT_FILE7 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $VENDOR_LIB_PATH $DIT_FILE51 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $VENDOR_LIB_PATH $DIT_FILE52 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $VENDOR_LIB_PATH $DIT_FILE53 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $VENDOR_LIB_PATH $DIT_FILE54 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $VENDOR_LIB_PATH $DIT_FILE55 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $VENDOR_LIB_PATH $DIT_FILE56 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $VENDOR_LIB_PATH $DIT_FILE57 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $VENDOR_LIB_PATH $DIT_FILE58 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $VENDOR_LIB_PATH $DIT_FILE59 $FILE_EXTENSION1 $DITFW_PATH
	file_modify_path $DataSetditSCidGen_PATH $DIT_FILE21 $FILE_EXTENSION3 $DITFW_PATH
	file_modify_path $DataSetDB_PATH $DIT_FILE22 $FILE_EXTENSION3 $DITFW_PATH
	file_modify_path $BIN_PATH $DIT_FILE26 $FILE_EXTENSION5 $DITFW_PATH
	file_modify_path $BIN_PATH $DIT_FILE26 $FILE_EXTENSION6 $DITFW_PATH
	file_modify_path $BIN_PATH $DIT_FILE27 $FILE_EXTENSION5 $DITFW_PATH
	file_modify_path $BIN_PATH $DIT_FILE28 $FILE_EXTENSION8 $DITFW_PATH
	file_modify_path $BIN_PATH $DIT_FILE29 $FILE_EXTENSION5 $DITFW_PATH
	file_modify_path $BIN_PATH $DIT_FILE30 $FILE_EXTENSION9 $DITFW_PATH
	echo $FINISH_RESULT > $DITFW_PATH$FINISH_RESULT_FILE
	chmod 666 $DITFW_PATH$FINISH_RESULT_FILE
	ls -al /data/DIT_fw/ >> $DITFWLOG_PATH"DITinit_log"
	chmod 666 $DITFWLOG_PATH"DITinit_log"
	mount -o ro,remount /system
	start cameraserver

	return 0
}
echo "Start DIT_fw init" >> $DITFWLOG_PATH"DITinit_log"
check_file_modify_path_finished;
echo "End DIT_fw init" >> $DITFWLOG_PATH"DITinit_log"
exit 0
