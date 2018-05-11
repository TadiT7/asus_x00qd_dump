#!/system/bin/sh

echo 633300 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1593600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 1766400 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo interactive > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
