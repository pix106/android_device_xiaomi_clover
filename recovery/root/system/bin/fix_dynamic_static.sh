#!/system/bin/sh
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2024 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

source /system/bin/lavenderfuncs.sh

# do the work
processit() {
	local F="/system/etc/recovery.fstab";
	local src_fstab="/system/etc/recovery-dynamic-44-flags.fstab";

	# see which variant we are running
	local K=$(getprop "ro.orangefox.kernel_ver");
	local V=$(getprop "ro.orangefox.variant");
	if [ "$K" = "4.4" -o "$V" = "default" -o "$V" = "kernel_44" ]; then
		TESTING_LOG "Dynamic build, with v4.4 kernel";
	else
		TESTING_LOG "Dynamic build, with v4.19 kernel";
	fi

	local D=$(rom_has_dynamic_partitions);  
	if [ "$D" = "1" ]; then
		TESTING_LOG "Dynamic ROM";
    		resetprop "fox_dynamic_device" "1";
		if [ "$K" = "4.4" -o "$V" = "default" -o "$V" = "kernel_44" ]; then
			cat $src_fstab >> $F;
		fi
	else
    		TESTING_LOG "Non-dynamic ROM";
    		TESTING_LOG "Discarding the 'Unmap Super Devices' menu";
    		resetprop "fox_dynamic_device" "0";

    		if [ "$K" = "4.19" -o "$V" = "kernel_419" ]; then
    			TESTING_LOG "Kernel 4.19 build: adjusting some flags";
			sed -i -e "s/ro,//g" $F; # remove the readonly flag
			sed -i -e '/erofs/d' $F; # remove all erofs lines
    		fi
	fi

	# cleanup
	rm -f $src_fstab;
}

# --- #
TESTING_LOG "Running $0";
dyn=$(is_dynamic_build);
[ "$dyn" = "1" ] && processit;

TESTING_LOG "Setting selinux to permissive";
setenforce 0;

exit 0;
#
