#!/vendor/bin/sh
LOG_TAG="PushMediaFiles"
logi ()
{
	/vendor/bin/log -t $LOG_TAG -p i "$@"
}

firstboot=`getprop persist.asus.media_copied`
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

if [ "$firstboot" != "1" ]; then
    mv_file
fi
