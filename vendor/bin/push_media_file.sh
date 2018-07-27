#!/vendor/bin/sh
LOG_TAG="PushMediaFiles"
logi ()
{
	/vendor/bin/log -t $LOG_TAG -p i "$@"
}

checkUserData=`mount | grep "/data type f2fs"`
dcim_folder="/sdcard/DCIM"
music_folder="/sdcard/Music"

mv_file() {

#add loop to wait system mount /sdcard/DCIM
while [ ! -d "$dcim_folder" ]
do
	logi "DCIM folder not found, sleep 2 second."
	sleep 2
done

	logi "Found $dcim_folder, keep going."

#add loop to wait system mount /sdcard/Music
while [ ! -d "$music_folder" ]
do
	logi "Music folder not found, sleep 2 second."
	sleep 2
done

	logi "Found $music_folder, keep going."

    mkdir -p /sdcard/DCIM
    mkdir -p /sdcard/Movies
    mkdir -p /sdcard/Music
    cp -r /vendor/etc/MediaFiles/asus_prebuild_media/DCIM/* /sdcard/DCIM/
    cp -r /vendor/etc/MediaFiles/asus_prebuild_media/Movies/* /sdcard/Movies/
    cp -r /vendor/etc/MediaFiles/asus_prebuild_media/Music/* /sdcard/Music/
   setprop persist.asus.media_copied 1
}
logi "checkUserData = $checkUserData"
while [ "$checkUserData" = "" ]
do
	logi "UserData partition is not Mounted, sleep 2 second."
	sleep 2
	checkUserData=`mount | grep "/data type f2fs"`
done

sleep 1

firstboot=`getprop persist.asus.media_copied`

if [ "$firstboot" != "1" ]; then
	logi "Need to copy media file"
    mv_file
else
	logi "Do not copy media file"
fi
