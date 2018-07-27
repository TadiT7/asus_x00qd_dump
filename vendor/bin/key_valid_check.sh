#!/vendor/bin/sh
/vendor/bin/is_keybox_valid
/vendor/bin/is_keymaster_valid

wvkey_stat=`getprop atd.keybox.ready`
kmkey_stat=`getprop atd.keymaster.ready`

# start install_default


if [[ ("$wvkey_stat" != "TRUE") || ("$kmkey_stat" != "TRUE") ]]; then
    setprop asus.install.default 1
fi
