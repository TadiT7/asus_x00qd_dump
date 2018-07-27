#!/system/bin/sh

echo 633000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1612800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 1804800 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
