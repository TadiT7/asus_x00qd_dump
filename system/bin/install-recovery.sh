#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:19854582:67259c69f8845f1d339df0b04a47a901136d09c1; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:16401650:56363c8a919ccdac8b7ee2bd82fe86f2f5071dbe EMMC:/dev/block/bootdevice/by-name/recovery 67259c69f8845f1d339df0b04a47a901136d09c1 19854582 56363c8a919ccdac8b7ee2bd82fe86f2f5071dbe:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
