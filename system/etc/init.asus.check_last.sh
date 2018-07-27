#!/system/bin/sh


# Workaround - permissive
# echo asussetenforce:0 > /proc/rd

echo "ASDF: Check LastShutdown log." > /proc/asusevtlog
echo get_asdf_log > /proc/asusdebug

# Workaround - enforce
# echo asussetenforce:1 > /proc/rd
