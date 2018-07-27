#!/system/bin/sh

cabc=3

echo $cabc > /proc/driver/cabc
echo 50 > /sys/devices/virtual/graphics/fb0/dynamic_fps
#setprop persist.asus.dfps 1
#setprop persist.asus.inoutdoor 1
