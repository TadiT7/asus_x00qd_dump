#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:19875062:9a828a1da6a3a7a258d76c1a1a019d9227398432; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:16471282:b92b77b0d2b893f883bc55890ad7a3d58173f2c8 EMMC:/dev/block/bootdevice/by-name/recovery 9a828a1da6a3a7a258d76c1a1a019d9227398432 19875062 b92b77b0d2b893f883bc55890ad7a3d58173f2c8:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
