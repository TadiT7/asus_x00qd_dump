#!/vendor/bin/sh

/vendor/bin/is_keybox_valid
/vendor/bin/is_keymaster_valid

# start install_key_server
setprop "atd.start.key.install" 1
